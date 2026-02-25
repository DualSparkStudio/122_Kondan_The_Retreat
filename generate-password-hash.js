// Generate bcrypt password hash for admin user
import bcrypt from 'bcryptjs'
import readline from 'readline'

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
})

function question(query) {
  return new Promise(resolve => rl.question(query, resolve))
}

async function generateHash() {
  console.log('🔐 Bcrypt Password Hash Generator\n')
  console.log('This will generate a secure password hash for your admin user.\n')
  
  const password = await question('Enter the password you want to hash: ')
  
  console.log('\n🔄 Generating hash...')
  
  const hash = await bcrypt.hash(password, 10)
  
  console.log('\n✅ Password hash generated successfully!\n')
  console.log('='=60)
  console.log('Password:', password)
  console.log('='=60)
  console.log('Hash:', hash)
  console.log('='=60)
  console.log('\n📋 Use this hash in your SQL INSERT statement:')
  console.log(`\nINSERT INTO admin (email, password_hash, first_name, last_name, phone)`)
  console.log(`VALUES (`)
  console.log(`    'admin@kondantheretreat.com',`)
  console.log(`    '${hash}',`)
  console.log(`    'Admin',`)
  console.log(`    'Kondan',`)
  console.log(`    '+91 8275063636'`)
  console.log(`);`)
  console.log('\n')
  
  rl.close()
}

generateHash()
