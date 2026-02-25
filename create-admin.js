// Create Admin User for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import bcrypt from 'bcryptjs'
import dotenv from 'dotenv'
import readline from 'readline'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
})

function question(query) {
  return new Promise(resolve => rl.question(query, resolve))
}

async function createAdmin() {
  console.log('🔐 Create Admin User for Kondan The Retreat\n')
  console.log('='=50)
  
  try {
    // Get admin details
    const email = await question('Enter admin email: ')
    const password = await question('Enter admin password: ')
    const firstName = await question('Enter first name: ')
    const lastName = await question('Enter last name: ')
    const phone = await question('Enter phone number: ')
    const address = await question('Enter address (optional): ')
    
    console.log('\n🔄 Creating admin user...')
    
    // Hash password
    const passwordHash = await bcrypt.hash(password, 10)
    
    // Insert admin user
    const { data, error } = await supabase
      .from('admin')
      .insert({
        email: email.trim(),
        password_hash: passwordHash,
        first_name: firstName.trim(),
        last_name: lastName.trim(),
        phone: phone.trim(),
        address: address.trim() || null,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
    
    if (error) {
      if (error.code === '23505') {
        console.log('\n❌ Error: An admin with this email already exists!')
      } else {
        console.log('\n❌ Error creating admin:', error.message)
      }
      rl.close()
      return
    }
    
    console.log('\n✅ Admin user created successfully!')
    console.log('\n📋 Admin Details:')
    console.log('   Email:', email)
    console.log('   Name:', `${firstName} ${lastName}`)
    console.log('   Phone:', phone)
    console.log('\n🔑 Login Credentials:')
    console.log('   Email:', email)
    console.log('   Password:', password)
    console.log('\n⚠️  IMPORTANT: Save these credentials securely!')
    console.log('   You can login at: /admin/login')
    
  } catch (error) {
    console.log('\n❌ Unexpected error:', error.message)
  }
  
  rl.close()
}

createAdmin()
