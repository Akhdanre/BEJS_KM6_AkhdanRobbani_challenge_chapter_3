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

CREATE TABLE transaksi(
    id BIGSERIAL PRIMARY KEY,
    deskripsi TEXT NOT NULL,
    tanggal DATE NOT NULL,
    nominal BIGINT NOT NULL,
    jenis_id INTEGER NOT NULL,
    akun_id BIGINT NOT NULL
);

select
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
from
    INFORMATION_SCHEMA.COLUMNS
where
    table_name = 'transaksi';

CREATE TABLE jenis_transaksi(
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

select
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
from
    INFORMATION_SCHEMA.COLUMNS
where
    table_name = 'jenis_transaksi';

--add foreign key
ALTER TABLE
    akun
ADD
    CONSTRAINT fk_nasabah_akun FOREIGN KEY (nasabah_id) REFERENCES nasabah(id);

ALTER TABLE
    transaksi
ADD
    CONSTRAINT fk_transaksi_akun FOREIGN KEY (akun_id) REFERENCES akun(id);

ALTER TABLE
    transaksi
ADD
    CONSTRAINT fk_transaksi_jenis FOREIGN KEY (jenis_id) REFERENCES jenis_transaksi(id);

-- create data for table jenis transaksi
INSERT INTO
    jenis_transaksi (nama, description)
VALUES
    ('penarikan', 'penarikan saldo akun pribadi'),
    ('setor', 'setor tunai ke saldo akun');


--create data for table nasabah
INSERT INTO
    nasabah (nama, tgl_lahir, alamat, nomor_telepon)
VALUES
    (
        'Akhdan Robbani',
        '2003-08-12',
        'Babadan, Werungotok, Nganjuk',
        '085708574368'
    );

INSERT INTO
    akun (username, password, nasabah_id)
VALUES
    ('oukenzeumasio', 'rahasia', 1);

INSERT INTO
    akun (username, password, nasabah_id)
VALUES
    ('akhdanre', 'rahasia', 1);
