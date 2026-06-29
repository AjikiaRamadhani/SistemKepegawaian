const mysql = require('mysql2/promise');
const fs = require('fs');

(async () => {
  const conn = await mysql.createConnection({
    host: 'serverless-us-east4.sysp0000.db2.skysql.com',
    port: 4043,
    user: 'dbpgf42371551',
    password: 'R-znDoAg0y31vIeq5hhHUNtM',
    database: 'sky',
    ssl: { rejectUnauthorized: false },
    multipleStatements: true
  });

  // migration_wilayah - jalankan manual, skip DROP INDEX
  console.log('Running migration_wilayah...');
  await conn.query(`
    ALTER TABLE pegawai
      ADD COLUMN IF NOT EXISTS kecamatan VARCHAR(100) DEFAULT NULL,
      ADD COLUMN IF NOT EXISTS kabupaten VARCHAR(100) DEFAULT NULL,
      ADD COLUMN IF NOT EXISTS provinsi VARCHAR(100) DEFAULT NULL
  `).catch(e => console.log('migration warning (bisa diabaikan):', e.message));

  // Hapus kolom id_kecamatan kalau masih ada
  await conn.query(`ALTER TABLE pegawai DROP COLUMN id_kecamatan`)
    .catch(e => console.log('drop column warning (bisa diabaikan):', e.message));

  console.log('migration_wilayah selesai');

  // seed_role_permission
  console.log('Running seed_role_permission...');
  let sql = fs.readFileSync('../seed_role_permission.sql', 'utf8');
  sql = sql.replace(/--.*$/gm, '').trim();
  await conn.query(sql).catch(e => console.log('seed error:', e.message));

  console.log('seed_role_permission selesai');
  console.log('Semua selesai!');
  conn.end();
})().catch(e => console.log('GAGAL:', e.message));