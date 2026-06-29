const bcrypt = require('bcrypt');
const db = require('./config/db');

async function createSuperadmin() {
    try {
        // Enkripsi password 'Admin123!'
        const hash = await bcrypt.hash('Admin123!', 10);
        
        // Buat Role
        await db.query(`INSERT IGNORE INTO user_role (id, nama_role) VALUES (1, 'Superadmin'), (2, 'Manager HRD'), (3, 'Admin HRD')`);
        
        // Masukkan akun ke tabel user
        await db.query(`INSERT INTO user (id_role, username, email, nama, password_hash, disabled) 
                        VALUES (1, 'superadmin', 'admin@jmc.com', 'Super Admin', ?, 0)`, [hash]);
        
        console.log('✅ Akun berhasil dibuat! Username: superadmin | Password: Admin123!');
        process.exit();
    } catch (error) {
        console.error('Gagal membuat akun:', error);
        process.exit(1);
    }
}
createSuperadmin();