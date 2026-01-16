const http = require("http");

// Kubernetes injects the pod name in the HOSTNAME env variable
const podName = process.env.HOSTNAME || "unknown-pod";

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end(`Hello from Node.js in Kubernetes!\nServed by pod: ${podName}\n`);
});

server.listen(3000, () => {
  console.log(`Server running on port 3000, pod: ${podName}`);
});
