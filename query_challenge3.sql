-- Active: 1710850075448@@127.0.0.1@5432@bank_system
CREATE DATABASE bank_system;

----------------- SHOW TABLE PENGGANTI /DT -----------------
SELECT
    *
FROM
    pg_catalog.pg_tables
WHERE
    schemaname NOT IN ('pg_catalog', 'information_schema');

----------------- membuat table nasabah -----------------
CREATE TABLE nasabah(
    id BIGSERIAL PRIMARY KEY,
    nama VARCHAR(150) NOT NULL,
    tgl_lahir DATE NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    nomor_telepon VARCHAR(13) NOT NULL
);

----------------- DESCRIBE TABLE /d+ -----------------
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

----------------- membuat table akun -----------------
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

----------------- membuat table transaksi -----------------
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

----------------- membuat table jenis_transaksi -----------------
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

----------------- add foreign key -----------------
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

----------------- create data for table jenis transaksi -----------------
INSERT INTO
    jenis_transaksi (nama, description)
VALUES
    ('penarikan', 'penarikan saldo akun pribadi'),
    ('setor', 'setor tunai ke saldo akun');

----------------- create data for table nasabah -----------------
INSERT INTO
    nasabah (nama, tgl_lahir, alamat, nomor_telepon)
VALUES
    (
        'Akhdan Robbani',
        '2003-08-12',
        'Babadan, Werungotok, Nganjuk',
        '085708574368'
    );

----------------- create data for table akun -----------------
INSERT INTO
    akun (username, password, nasabah_id)
VALUES
    ('oukenzeumasio', 'rahasia', 1);

INSERT INTO
    akun (username, password, nasabah_id)
VALUES
    ('akhdanre', 'rahasia', 1);

UPDATE
    akun
set
    is_active = true
where
    id = 1;

SELECT
    *
from
    nasabah
    RIGHT JOIN akun on nasabah.id = akun.nasabah_id;

----------------- memulai transaksi untuk setor saldo serta melakukan update field saldo pada table akun -----------------
WITH saldo_akun AS (
    SELECT
        id,
        saldo
    FROM
        akun
    WHERE
        id = 1
),
transaksi_process AS (
    INSERT INTO
        transaksi (tanggal, nominal, jenis_id, akun_id, deskripsi)
    VALUES
        (
            '2024-03-19',
            40000,
            2,
            1,
            'melakukan transaksi setor saldo'
        ) RETURNING akun_id,
        nominal
)
UPDATE
    akun
SET
    saldo = transaksi_process.nominal + saldo_akun.saldo
FROM
    transaksi_process,
    saldo_akun
WHERE
    akun.id = transaksi_process.akun_id
    AND akun.id = saldo_akun.id;

----------------- show hasil transaksi -----------------
SELECT
    *
FROM
    akun
    RIGHT JOIN transaksi ON akun.id = transaksi.akun_id;

---------------------------------------- show all data nasabah, akun dan transaksi ----------------------------------------
SELECT
    nasabah.nama,
    akun.username,
    akun.saldo,
    transaksi.id as id_transaksi,
    transaksi.deskripsi,
    transaksi.nominal as transaksi_nominal,
    jenis_transaksi.nama as kategori
FROM
    nasabah
    RIGHT JOIN akun ON akun.nasabah_id = nasabah.id
    RIGHT JOIN transaksi on transaksi.akun_id = akun.id
    LEFT JOIN jenis_transaksi on transaksi.jenis_id = jenis_transaksi.id;

----------------- memulai transaksi untuk penarikan saldo serta melakukan update field saldo pada table akun -----------------
WITH saldo_akun AS (
    SELECT
        id,
        saldo
    FROM
        akun
    WHERE
        id = 1
),
transaksi_process AS (
    INSERT INTO
        transaksi (tanggal, nominal, jenis_id, akun_id, deskripsi)
    VALUES
        (
            '2024-03-19',
            40000,
            1,
            1,
            'melakukan transaksi penarikan saldo'
        ) RETURNING akun_id,
        nominal
)
UPDATE
    akun
SET
    saldo = saldo_akun.saldo - transaksi_process.nominal
FROM
    transaksi_process,
    saldo_akun
WHERE
    akun.id = transaksi_process.akun_id
    AND akun.id = saldo_akun.id;

------- mendaptkan jumlah transaksi berhdasarkan jenis ----------
WITH jumlah_transaksi AS (
    SELECT
        akun_id,
        COUNT(jenis_id)
    FROM
        transaksi
    GROUP BY
        akun_id,
        jenis_id
)
SELECT
    nasabah.nama,
    akun.username,
    jenis_transaksi.nama as jenis_transaksi,
    jumlah_transaksi.count as banyak_transaksi
FROM
    akun
    LEFT JOIN nasabah on akun.nasabah_id = akun.id
    RIGHT JOIN jumlah_transaksi ON akun.id = jumlah_transaksi.akun_id
    LEFT JOIN jenis_transaksi ON jumlah_transaksi.count = jenis_transaksi.id;

SELECT
    *
FROM
    transaksi;

DELETE FROM
    transaksi
WHERE
    id = 2;

SELECT
    *
FROM
    akun;

DELETE FROM
    akun
WHERE
    id = 2
    AND is_active = false;

------ hilangkan semua bukti transaksi -------
DELETE FROM
    transaksi
WHERE
    akun_id = 1;

DELETE FROM
    akun
WHERE
    id = 1