-- Active: 1710815950743@@127.0.0.1@5432@bank_system
CREATE DATABASE bank_system;

-- SHOW TABLE PENGGANTI /DT
SELECT
    *
FROM
    pg_catalog.pg_tables
WHERE
    schemaname NOT IN ('pg_catalog', 'information_schema');

CREATE TABLE nasabah(
    id BIGSERIAL PRIMARY KEY,
    nama VARCHAR(150) NOT NULL,
    tgl_lahir DATE NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    nomor_telepon VARCHAR(13) NOT NULL
);

-- DESCRIBE TABLE /d+
select
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
from
    INFORMATION_SCHEMA.COLUMNS
where
    table_name = 'nasabah';

CREATE TABLE akun(
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL,
    is_active BOOLEAN DEFAULT false,
    saldo BIGINT DEFAULT 0,
    nasabah_id BIGINT NOT NULL
);

-- DESCRIBE TABLE /d+
select
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
from
    INFORMATION_SCHEMA.COLUMNS
where
    table_name = 'akun';

-- CREATE TABLE transaksi(
--     id BIGSERIAL PRIMARY KEY,
--     deskripsi TEXT NOT NULL,
--     tanggal DATE NOT NULL,
--     nominal BIGINT NOT NULL,
--     jenis 
-- )