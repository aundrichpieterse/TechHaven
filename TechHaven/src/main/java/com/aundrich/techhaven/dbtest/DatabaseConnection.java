package com.aundrich.techhaven.dbtest;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Provides a method to get a connection to the MySQL database.
 */
public class DatabaseConnection {

    // Database connection URL, user, and password.
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
    private static final String JDBC_USER = ""; // Provide own username
    private static final String JDBC_PASSWORD = ""; // Provide own password

    // Load the MySQL JDBC driver.
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Error loading MySQL JDBC driver.");
            e.printStackTrace();
        }
    }

    /**
     * Returns a connection to the database.
     * 
     * @return A Connection object.
     * @throws SQLException If it is unable to connect.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }

}
