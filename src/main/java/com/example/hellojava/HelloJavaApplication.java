package com.example.hellojava;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HelloJavaApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(HelloJavaApplication.class, args);
	}

	@Override
	public void run(String... args) {
		System.out.println("Hello wlocme to Java code");
	}

}
