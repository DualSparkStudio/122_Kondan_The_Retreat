# Netlify Deployment Checklist & Potential Issues

## ✅ FIXED ISSUES
1. ✅ Missing build command in netlify.toml
2. ✅ Syntax error in netlify/functions/auth.js (line 20)
3. ✅ Duplicate variable declaration in netlify/functions/simple-admin-auth.js

---

## 🔴 CRITICAL - Must Fix Before Deployment

### 1. Missing Environment Variables
**Impact:** Functions will fail at runtime

Required environment variables in Netlify dashboard:
```bash
# Supabase (CRITICAL)
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Razorpay Payment (CRITICAL for bookings)
VITE_RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_SECRET=your_razorpay_key_secret

# Email (CRITICAL for notifications)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_app_password
ADMIN_EMAIL=riverbreezehomestay@gmail.com

# Optional but recommended
GOOGLE_PLACES_API_KEY=your_google_places_api_key
VITE_SLUG_SECRET=your-super-secret-key-for-slug-generation
APP_URL=https://your-domain.netlify.app
```

**Action Required:**
- Go to Netlify Dashboard → Site Settings → Environment Variables
- Add ALL variables listed above
- Note: Variables prefixed with `VITE_` are exposed to frontend
- Variables without `VITE_` are server-side only

### 2. Inconsistent Environment Variable Names
**Impact:** Functions may fail due to wrong variable names

**Issues Found:**
- `netlify/functions/auth.js` uses `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`
- `netlify/functions/hybrid-auth.js` uses `SUPABASE_URL` and `SUPABASE_ANON_KEY` (without VITE_ prefix)
- `netlify/functions/calendar-feed.js` uses `VITE_SUPABASE_URL` but `SUPABASE_SERVICE_ROLE_KEY`

**Recommendation:** Standardize to:
- Frontend (src/): `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`
- Backend (netlify/functions/): `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`

---

## 🟡 HIGH PRIORITY - Should Fix

### 3. TypeScript Strict Mode Issues
**Impact:** Build may fail with TypeScript errors

**Issues Found:**
- Multiple `any` types used throughout codebase
- Strict mode enabled in tsconfig.app.json
- `noUnusedLocals` and `noUnusedParameters` enabled

**Files with potential issues:**
- src/pages/RoomDetail.tsx (line 30: `any[]`)
- src/pages/BookingForm.tsx (multiple `any` types)
- src/pages/AdminCalendar.tsx (line 11: `any[]`)
- src/lib/api.ts (multiple function parameters typed as `any`)
- src/lib/razorpay.ts (callback parameters typed as `any`)

**Action Required:**
- Run `npm run build` locally to catch TypeScript errors
- Either fix type issues or temporarily disable strict checks

### 4. Missing Type Definitions
**Impact:** Build warnings or errors

**Issue:** Custom type definition file exists but may not cover all cases
- src/types/yet-another-react-lightbox.d.ts

**Action Required:**
- Verify all third-party libraries have type definitions
- Check for missing `@types/*` packages

### 5. Dynamic Imports
**Impact:** May cause build issues if not properly configured

**Files using dynamic imports:**
- src/pages/Dashboard.tsx (line 123: email-service)
- src/pages/BookingForm.tsx (line 725: email-service)

**Action Required:**
- Verify these imports work in production build
- Consider pre-importing if issues occur

---

## 🟢 MEDIUM PRIORITY - Monitor

### 6. Console Logs in Production
**Impact:** Performance and security concerns

**Files with console logs:**
- netlify/functions/auth.js (line 20)
- netlify/functions/create-razorpay-order.js (lines 23, 39, 105)
- netlify/functions/send-booking-confirmation.js (multiple)
- netlify/functions/send-contact-email.js (multiple)
- netlify/functions/simple-login.js (multiple)

**Recommendation:**
- Remove or wrap in `if (process.env.NODE_ENV === 'development')`
- Use proper logging service for production

### 7. Deprecated Dependencies
**Impact:** Security vulnerabilities and future compatibility

**Warnings from npm install:**
```
- inflight@1.0.6 (memory leak)
- rimraf@3.0.2 (no longer supported)
- glob@7.2.3 and glob@8.1.0 (no longer supported)
- npmlog@5.0.1 (no longer supported)
- @studio-freight/lenis@1.0.42 (renamed to 'lenis')
- react-beautiful-dnd@13.1.1 (deprecated)
- eslint@8.57.1 (no longer supported)
```

**Action Required:**
- Update package.json to use newer versions
- Replace deprecated packages:
  ```bash
  npm uninstall @studio-freight/lenis
  npm install lenis
  ```
- Consider alternatives for react-beautiful-dnd
- Update ESLint to v9

### 8. Large Bundle Size
**Impact:** Slow page loads

**Potential issues:**
- Multiple animation libraries (GSAP, Framer Motion, AOS, Lenis)
- Full FullCalendar library
- Large dependencies

**Action Required:**
- Enable code splitting in vite.config.ts
- Lazy load heavy components
- Analyze bundle with `npm run build -- --analyze`

### 9. Missing Error Boundaries
**Impact:** Poor user experience on errors

**Issue:** No React error boundaries detected in codebase

**Action Required:**
- Add error boundaries to catch runtime errors
- Prevent white screen of death in production

---

## 🔵 LOW PRIORITY - Nice to Have

### 10. Source Maps in Production
**Impact:** Security concern (exposes source code)

**Current setting:** `sourcemap: true` in vite.config.ts

**Recommendation:**
- Disable for production or use hidden source maps
- Update vite.config.ts:
  ```typescript
  build: {
    outDir: 'dist',
    sourcemap: process.env.NODE_ENV === 'development',
  }
  ```

### 11. CORS Headers
**Impact:** May cause issues with external API calls

**Current setup:** CORS enabled in server config and functions

**Action Required:**
- Verify CORS headers work with your domain
- Update `APP_URL` environment variable to production URL

### 12. Security Headers
**Impact:** Security best practices

**Current headers in netlify.toml:**
- ✅ X-Frame-Options: DENY
- ✅ X-XSS-Protection: 1; mode=block
- ✅ X-Content-Type-Options: nosniff
- ✅ Referrer-Policy: strict-origin-when-cross-origin
- ✅ Permissions-Policy configured

**Recommendation:** Add CSP (Content Security Policy) header

---

## 📋 Pre-Deployment Testing Checklist

### Local Build Test
```bash
# 1. Clean install
rm -rf node_modules package-lock.json
npm install

# 2. Run build locally
npm run build

# 3. Preview production build
npm run preview

# 4. Check for TypeScript errors
npx tsc --noEmit

# 5. Run linter
npm run lint
```

### Environment Variables Test
```bash
# Test with Netlify CLI
netlify dev

# Verify all functions work:
# - Auth (login/register)
# - Booking creation
# - Payment processing
# - Email notifications
# - Calendar feed
```

### Function Testing
Test each serverless function:
- [ ] `/api/auth` - User authentication
- [ ] `/api/simple-login` - Admin login
- [ ] `/api/simple-admin-auth` - Admin operations
- [ ] `/api/create-razorpay-order` - Payment orders
- [ ] `/api/send-booking-confirmation` - Email notifications
- [ ] `/api/send-contact-email` - Contact form
- [ ] `/api/get-google-reviews` - Reviews fetching
- [ ] `/api/calendar-feed` - iCal feed
- [ ] `/calendar/feed.ics` - Calendar redirect

---

## 🚀 Deployment Steps

1. **Fix Critical Issues**
   - Add all environment variables to Netlify
   - Standardize environment variable names
   - Test build locally

2. **Commit and Push**
   ```bash
   git add .
   git commit -m "Fix deployment issues"
   git push origin main
   ```

3. **Monitor Deployment**
   - Watch Netlify build logs
   - Check for function bundling errors
   - Verify build completes successfully

4. **Post-Deployment Testing**
   - Test user registration/login
   - Test booking flow with payment
   - Test admin panel access
   - Test email notifications
   - Check calendar feed
   - Verify all pages load correctly

5. **Monitor Errors**
   - Check Netlify Functions logs
   - Monitor browser console for errors
   - Test on multiple devices/browsers

---

## 🔧 Quick Fixes

### If Build Fails with TypeScript Errors:
```typescript
// Temporarily disable strict checks in tsconfig.app.json
{
  "compilerOptions": {
    "strict": false,
    "noUnusedLocals": false,
    "noUnusedParameters": false
  }
}
```

### If Functions Fail:
1. Check Netlify Functions logs
2. Verify environment variables are set
3. Check function syntax errors
4. Verify dependencies are installed

### If Payment Fails:
1. Verify Razorpay keys are correct
2. Check both `VITE_RAZORPAY_KEY_ID` and `RAZORPAY_KEY_ID` are set
3. Test in Razorpay test mode first

### If Emails Don't Send:
1. Verify SMTP credentials
2. Enable "Less secure app access" for Gmail (or use App Password)
3. Check email function logs in Netlify

---

## 📞 Support Resources

- Netlify Docs: https://docs.netlify.com
- Netlify Functions: https://docs.netlify.com/functions/overview
- Vite Build Issues: https://vitejs.dev/guide/build.html
- Supabase Docs: https://supabase.com/docs
