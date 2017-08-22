<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	
	



<%@ page import="java.sql.*"  %>
<%
int x = Integer.parseInt(request.getParameter("sample"));

out.println(x);
  // Read RDS connection information from the environment
  String dbName = "score";
  String userName = "outsecure";
  String password = "outsecure";
  String hostname = "outsecure.cftgxedbbz0s.us-east-1.rds.amazonaws.com";
  String port = "1433";
  //String jdbcUrl = "jdbc:sqlserver://" + hostname + ":" +
    //port + "/" + dbName + "?user=" + userName + "&password=" + password;
  String jdbcUrl = "jdbc:sqlserver://outsecure.cftgxedbbz0s.us-east-1.rds.amazonaws.com:1433;databaseName=score";
  // Load the JDBC driver
  try {
    System.out.println("Loading driver...");
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    System.out.println("Driver loaded!");
  } catch (ClassNotFoundException e) {
    throw new RuntimeException("Cannot find the driver in the classpath!", e);
  }

  Connection conn = null;
  Statement setupStatement = null;
  Statement readStatement = null;
  ResultSet resultSet = null;
  String results = "";
  int numresults = 0;
  String statement = null;

  try {
    // Create connection to RDS DB instance
    conn = DriverManager.getConnection(jdbcUrl,userName,password);
    
    // Create a table and write two rows
    setupStatement = conn.createStatement();
    //String createTable = "CREATE TABLE Beanstalk (Resource char(50));";
    String insertRow1 = "INSERT INTO Beanstalk (Resource) VALUES ('EC2 Instance8');";
    String insertRow2 = "INSERT INTO Beanstalk (Resource) VALUES ('RDS Instance9');";
    String insertRow3 = "Insert into critical values('"+x+"');";
    
    //setupStatement.addBatch(createTable);
    setupStatement.addBatch(insertRow1);
    setupStatement.addBatch(insertRow2);
    setupStatement.addBatch(insertRow3);
    out.println("data inserted");
    setupStatement.executeBatch();
    setupStatement.close();
    
  } catch (SQLException ex) {
    // Handle any errors
    System.out.println("SQLException: " + ex.getMessage());
    System.out.println("SQLState: " + ex.getSQLState());
    System.out.println("VendorError: " + ex.getErrorCode());
  } finally {
    System.out.println("Closing the connection.");
    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
  }

  try {
    conn = DriverManager.getConnection(jdbcUrl);
    
    readStatement = conn.createStatement();
    resultSet = readStatement.executeQuery("SELECT Resource FROM Beanstalk;");

    resultSet.first();
    results = resultSet.getString("Resource");
    resultSet.next();
    results += ", " + resultSet.getString("Resource");
    
    resultSet.close();
    readStatement.close();
    conn.close();

  } catch (SQLException ex) {
    // Handle any errors
    System.out.println("SQLException: " + ex.getMessage());
    System.out.println("SQLState: " + ex.getSQLState());
    System.out.println("VendorError: " + ex.getErrorCode());
  } finally {
       System.out.println("Closing the connection.");
      if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
  }
%>

	
</body>
</html>