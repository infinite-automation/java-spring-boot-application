package com.example.hellojava;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(OutputCaptureExtension.class)
class HelloJavaRunnerTests {
    @Test
    void printsGreetingOnStartup(CapturedOutput output) {
        new HelloJavaApplication().run();

        assertThat(output.getOut())
                .isEqualTo("Hello wlocme to Java code" + System.lineSeparator());
    }
}
