// Test Admin Login
import fetch from 'node-fetch'

async function testLogin() {
  console.log('🔐 Testing Admin Login\n')
  console.log('==================================================')
  
  const loginData = {
    action: 'login',
    email: 'admin@kondantheretreat.com',
    password: 'Admin@123'
  }
  
  console.log('Attempting login with:')
  console.log('  Email:', loginData.email)
  console.log('  Password:', loginData.password)
  console.log('\n🔄 Sending request to Netlify function...\n')
  
  try {
    const response = await fetch('http://localhost:8888/.netlify/functions/simple-admin-auth', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(loginData)
    })
    
    const data = await response.json()
    
    console.log('Response Status:', response.status)
    console.log('Response Data:', JSON.stringify(data, null, 2))
    
    if (response.status === 200 && data.success) {
      console.log('\n✅ LOGIN SUCCESSFUL!')
      console.log('==================================================')
      console.log('Admin Details:')
      console.log('  Name:', data.user.first_name, data.user.last_name)
      console.log('  Email:', data.user.email)
      console.log('  Phone:', data.user.phone)
      console.log('==================================================')
    } else {
      console.log('\n❌ LOGIN FAILED')
      console.log('Error:', data.error || 'Unknown error')
    }
    
  } catch (error) {
    console.log('\n❌ Request failed:', error.message)
    console.log('\n⚠️  Make sure the development server is running:')
    console.log('   npm run dev')
  }
}

testLogin()
