const AWS = require("aws-sdk");
const sql = require("mssql");

const secretsManager = new AWS.SecretsManager({ region: process.env.AWS_REGION });

async function getDbCredentials(secretArn) {
  const data = await secretsManager.getSecretValue({ SecretId: secretArn }).promise();
  const secret = JSON.parse(data.SecretString);
  return {
    user: secret.username,
    password: secret.password
  };
}

exports.handler = async (event) => {
  const path = event.requestContext.http.path;


  if (path === "/") {
    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        message: "Hello from Node.js Lambda WebAPI! (test)",
        time: new Date().toISOString()
      })
    };
  }

  
  if (path === "/health") {
    let dbStatus = "Unknown";

    try {
      const creds = await getDbCredentials(process.env.DB_SECRET_ARN);

      const pool = await sql.connect({
        user: creds.user,
        password: creds.password,
        server: process.env.DB_HOST,
        database: process.env.DB_NAME,
        port: parseInt(process.env.DB_PORT),
        options: { encrypt: true, trustServerCertificate: true }
      });

      const result = await pool.request().query("SELECT @@SERVERNAME AS serverName");
      dbStatus = `Connected to SQL Server: ${result.recordset[0].serverName}`;

    } catch (err) {
      dbStatus = `Database Error: ${err.message}`;
    }

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        status: "OK",
        time: new Date().toISOString(),
        dbStatus
      })
    };
  }


  return {
    statusCode: 404,
    body: JSON.stringify({ error: "Route not found" })
  };
};

