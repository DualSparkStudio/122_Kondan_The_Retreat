// Check what tables exist in the database
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_SERVICE_ROLE_KEY

console.log('Checking existing tables in Kondan The Retreat database...\n')

const supabase = createClient(supabaseUrl, supabaseKey)

async function checkTables() {
  try {
    // Query to get all tables in public schema
    const { data, error } = await supabase.rpc('exec_sql', {
      query: `
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        ORDER BY table_name;
      `
    })
    
    if (error) {
      console.log('Trying alternative method...')
      
      // Try checking common tables
      const tables = ['rooms', 'bookings', 'admin', 'users', 'tourist_attractions', 'reviews']
      
      for (const table of tables) {
        const { error: tableError } = await supabase.from(table).select('count').limit(1)
        if (!tableError) {
          console.log(`✅ Table exists: ${table}`)
        } else {
          console.log(`❌ Table missing: ${table}`)
        }
      }
    } else {
      console.log('Tables found:')
      data.forEach(row => console.log(`  - ${row.table_name}`))
    }
    
  } catch (error) {
    console.log('Error:', error.message)
  }
}

checkTables()
