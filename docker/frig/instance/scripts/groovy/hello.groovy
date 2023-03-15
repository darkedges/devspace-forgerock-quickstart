Response response = new Response(Status.OK)
response.entity = java.net.InetAddress.getLocalHost().getHostName();
return response