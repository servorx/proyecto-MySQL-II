DROP DATABASE proyecto;
CREATE DATABASE proyecto; 
USE proyecto;


CREATE TABLE IF NOT EXISTS dane_departments (
  dane_code VARCHAR(2) PRIMARY KEY,
  name VARCHAR(60) UNIQUE NOT NULL  
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS dane_municipalities (
  dane_department_code VARCHAR(2) NOT NULL,   
  dane_municipality_code VARCHAR(3) NOT NULL, 
  name VARCHAR(60) NOT NULL,                  
  PRIMARY KEY (dane_department_code, dane_municipality_code), 
  CONSTRAINT fk_dane_department_mun FOREIGN KEY (dane_department_code) REFERENCES dane_departments(dane_code)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS countries (
  iso_code VARCHAR(6) PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  alfaisotwo VARCHAR(2) UNIQUE NOT NULL,
  alfaisothree VARCHAR(4) UNIQUE NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS subdivision_categories(
  id INT PRIMARY KEY AUTO_INCREMENT,
  description VARCHAR(40) UNIQUE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS state_or_regions(
  code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(60) UNIQUE NOT NULL,
  country_id VARCHAR(6) NOT NULL,
  code3166 VARCHAR(10) UNIQUE,
  subdivision_id INT,
  dane_department_code VARCHAR(2) UNIQUE,
  CONSTRAINT fk_dane_department_code_state_or_regions FOREIGN KEY (dane_department_code) REFERENCES dane_departments (dane_code),
  CONSTRAINT fk_subdivision_id_state_or_regions FOREIGN KEY (subdivision_id) REFERENCES subdivision_categories(id),
  CONSTRAINT fk_country_id_state_or_regions FOREIGN KEY (country_id) REFERENCES countries(iso_code)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS cities_or_municipalities (
  code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(60),
  statereg_id VARCHAR(10),
  dane_department_code VARCHAR(2),
  dane_municipality_code VARCHAR(3),
  CONSTRAINT fk_dane_municipality_city FOREIGN KEY (dane_department_code, dane_municipality_code) REFERENCES dane_municipalities(dane_department_code, dane_municipality_code)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS types_identifications(
  id INT PRIMARY KEY AUTO_INCREMENT,
  description VARCHAR(60) UNIQUE NOT NULL,
  sufix VARCHAR(5) UNIQUE NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description VARCHAR(60) UNIQUE NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS audiences (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description VARCHAR(60) UNIQUE NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS emails (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email_name VARCHAR(80) UNIQUE NOT NULL,
  email_type VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS phones (
  id INT PRIMARY KEY AUTO_INCREMENT,
  phone_number VARCHAR(20) UNIQUE NOT NULL,
  phone_country_code VARCHAR(10),
  phone_type VARCHAR(10)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS companies (
  id INT PRIMARY KEY AUTO_INCREMENT,
  type_id INT,
  name VARCHAR(80),
  category_id INT,
  city_id VARCHAR(10),
  audience_id INT,
  phone_id INT,
  email_id INT,
  isactive BOOLEAN,
  CONSTRAINT fk_type_id_companies FOREIGN KEY (type_id) REFERENCES types_identifications(id),
  CONSTRAINT fk_category_id_companies FOREIGN KEY (category_id) REFERENCES categories(id),
  CONSTRAINT fk_city_id_companies FOREIGN KEY (city_id) REFERENCES cities_or_municipalities(code),
  CONSTRAINT fk_audience_id_companies FOREIGN KEY (audience_id) REFERENCES audiences(id),
  CONSTRAINT fk_email_id_companies FOREIGN KEY (email_id) REFERENCES emails(id),
  CONSTRAINT fk_phone_id_companies FOREIGN KEY (phone_id) REFERENCES phones(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS memberships (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS periods (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) UNIQUE NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS benefits (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description VARCHAR(80),
  detail TEXT
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS membership_periods (
  membership_id INT,
  period_id INT,
  price DECIMAL(10,2),
  PRIMARY KEY(membership_id, period_id),
  CONSTRAINT fk_membership_id_membership_periods FOREIGN KEY (membership_id) REFERENCES memberships(id),
  CONSTRAINT fk_period_id_membership_periods FOREIGN KEY (period_id) REFERENCES periods(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS audience_benefits (
  audience_id INT,
  benefit_id INT,
  PRIMARY KEY(audience_id, benefit_id),
  CONSTRAINT fk_audience_id_audience_benefits FOREIGN KEY (audience_id) REFERENCES audiences(id),
  CONSTRAINT fk_benefit_id_audience_benefits FOREIGN KEY (benefit_id) REFERENCES benefits(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS membership_benefits (
  membership_id INT,
  period_id INT,
  audience_id INT,
  benefit_id INT,
  PRIMARY KEY (membership_id, period_id, audience_id, benefit_id),
  CONSTRAINT fk_membership_id_membership_benefits FOREIGN KEY (membership_id) REFERENCES memberships(id),
  CONSTRAINT fk_period_id_membership_benefits FOREIGN KEY (period_id) REFERENCES periods(id),
  CONSTRAINT fk_audience_id_membership_benefits FOREIGN KEY (audience_id) REFERENCES audiences(id),
  CONSTRAINT fk_benefit_id_membership_benefits FOREIGN KEY (benefit_id) REFERENCES benefits(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(60) UNIQUE,
  detail TEXT,
  price DECIMAL(10,2),
  image VARCHAR(80),
  category_id INT,
  CONSTRAINT fk_category_id_products FOREIGN KEY (category_id) REFERENCES categories(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS unit_of_measure (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description VARCHAR(60) UNIQUE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS company_products (
  company_id INT,
  product_id INT,
  price DECIMAL(10,2),
  unitmeasure_id INT,
  PRIMARY KEY(company_id, product_id),
  CONSTRAINT fk_company_id_company_products FOREIGN KEY (company_id) REFERENCES companies(id),
  CONSTRAINT fk_product_id_company_products FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT fk_unitmeasure_id_company_products FOREIGN KEY (unitmeasure_id) REFERENCES unit_of_measure(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS categories_polls (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(80) UNIQUE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS polls (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(80) UNIQUE,
  description TEXT,
  isactive BOOLEAN,
  categorypoll_id INT,
  CONSTRAINT fk_categorypoll_id_polls FOREIGN KEY (categorypoll_id) REFERENCES categories_polls(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS addresses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  street_address VARCHAR(80) NOT NULL,
  city_id VARCHAR(10) NOT NULL,
  CONSTRAINT fk_city_id_addresses FOREIGN KEY (city_id) REFERENCES cities_or_municipalities(code)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(80) NOT NULL,
  city_id VARCHAR(10),
  audience_id INT,
  phone_id INT,
  email_id INT,
  address_id INT,
  CONSTRAINT fk_audience_id_customers FOREIGN KEY (audience_id) REFERENCES audiences(id),
  CONSTRAINT fk_email_id_customers FOREIGN KEY (email_id) REFERENCES emails(id),
  CONSTRAINT fk_address_id_customers FOREIGN KEY (address_id) REFERENCES addresses(id),
  CONSTRAINT fk_phone_id_customers FOREIGN KEY (phone_id) REFERENCES phones(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS quality_products (
  product_id INT,
  customer_id INT,
  poll_id INT,
  company_id INT,
  daterating DATETIME,
  rating DECIMAL (5,2),
  PRIMARY KEY(product_id, customer_id, poll_id, company_id),
  CONSTRAINT fk_product_id_quality_products FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT fk_customer_id_quality_products FOREIGN KEY (customer_id) REFERENCES customers(id),
  CONSTRAINT fk_poll_id_quality_products FOREIGN KEY (poll_id) REFERENCES polls(id),
  CONSTRAINT fk_company_id_quality_products FOREIGN KEY (company_id) REFERENCES companies(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS rates (
  customer_id INT,
  company_id INT,
  poll_id INT,
  daterating DATETIME,
  rating DECIMAL (5,2),
  PRIMARY KEY(customer_id, company_id, poll_id),
  CONSTRAINT fk_customer_id_rates FOREIGN KEY (customer_id) REFERENCES customers(id),
  CONSTRAINT fk_company_id_rates FOREIGN KEY (company_id) REFERENCES companies(id),
  CONSTRAINT fk_poll_id_rates FOREIGN KEY (poll_id) REFERENCES polls(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS favorites (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  company_id INT,
  UNIQUE(customer_id, company_id),
  CONSTRAINT fk_customer_id_favorites FOREIGN KEY (customer_id) REFERENCES customers(id),
  CONSTRAINT fk_company_id_favorites FOREIGN KEY (company_id) REFERENCES companies(id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS detail_favorites (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  favorite_id INT,
  product_id INT,
  CONSTRAINT fk_favorite_id_detail_favorites FOREIGN KEY (favorite_id) REFERENCES favorites(id),
  CONSTRAINT fk_product_id_detail_favorites FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=INNODB;
