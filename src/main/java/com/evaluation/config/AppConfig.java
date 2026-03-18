package com.evaluation.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;

import javax.sql.DataSource;
import java.util.Properties;

import org.springframework.scheduling.annotation.EnableAsync;

@Configuration
@EnableAsync
@EnableTransactionManagement
@ComponentScan(basePackages = "com.evaluation")
@PropertySource("classpath:application.properties")
public class AppConfig {

    @Value("${db.driver}")        private String dbDriver;
    @Value("${db.url}")           private String dbUrl;
    @Value("${db.username}")      private String dbUsername;
    @Value("${db.password}")      private String dbPassword;
    @Value("${db.pool.maximumPoolSize:10}") private int maxPoolSize;
    @Value("${db.pool.minimumIdle:2}")      private int minIdle;

    @Value("${mail.host}")         private String mailHost;
    @Value("${mail.port}")         private int    mailPort;
    @Value("${mail.username}")     private String mailUsername;
    @Value("${mail.password}")     private String mailPassword;
    @Value("${mail.smtp.auth}")    private String mailAuth;
    @Value("${mail.smtp.starttls}")private String mailTls;

    // ── DataSource ────────────────────────────────────────────
    @Bean(destroyMethod = "close")
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(dbDriver);
        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUsername);
        config.setPassword(dbPassword);
        config.setMaximumPoolSize(maxPoolSize);
        config.setMinimumIdle(minIdle);
        config.setConnectionTimeout(30_000);
        config.setIdleTimeout(600_000);
        config.setMaxLifetime(1_800_000);
        config.setPoolName("CES-Pool");
        return new HikariDataSource(config);
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    // ── Mail Sender ───────────────────────────────────────────
    @Bean
    public JavaMailSenderImpl mailSender() {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(mailHost);
        sender.setPort(mailPort);
        sender.setUsername(mailUsername);
        sender.setPassword(mailPassword);

        Properties props = sender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth",               mailAuth);
        props.put("mail.smtp.starttls.enable",     mailTls);
        props.put("mail.debug", "false");
        return sender;
    }

    // ── Multipart (file upload) ───────────────────────────────
    @Bean
    public StandardServletMultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }
}
