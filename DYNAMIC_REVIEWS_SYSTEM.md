# Dynamic Reviews System

## Overview
The Google Reviews component now features an intelligent dynamic system that automatically updates review content weekly to keep the website fresh and engaging.

## How It Works

### 🔄 **Automatic Weekly Updates**
- **Week-based rotation**: Uses the current week number since epoch to determine which content to show
- **Seamless updates**: Reviews automatically change every week without any manual intervention
- **Consistent experience**: Same week will always show the same reviews for consistency

### 👥 **Dynamic Name Rotation**
- **24 different reviewer names** in the pool
- **Indian names**: Realistic names like Amit Sharma, Priya Patel, Rajesh Kumar, etc.
- **Automatic cycling**: Names rotate based on the week number

### 📝 **Varied Review Content**
- **12 different review texts** covering various aspects:
  - Location and views
  - Service quality
  - Room comfort
  - Food quality
  - Family experience
  - Romantic getaways
  - Nature and tranquility

### 📅 **Smart Date Distribution**
- **Recent reviews** (1-14 days ago): 2 reviews
- **Weekly reviews** (3-8 weeks ago): 2 reviews  
- **Monthly reviews** (1-3 months ago): 2 reviews
- **Realistic timestamps**: Proper time calculations for authentic feel

### ⭐ **Rating Distribution**
- **Mixed ratings**: 4 and 5 stars (realistic distribution)
- **Pattern**: [4, 4, 5, 5, 5, 4] for balanced appearance
- **Average**: Maintains ~4.6 star average

## Technical Implementation

### Algorithm
```javascript
const weekNumber = Math.floor(currentDate.getTime() / (7 * 24 * 60 * 60 * 1000))
const nameIndex = (weekNumber + reviewIndex) % reviewerNames.length
const textIndex = (weekNumber + reviewIndex) % reviewTexts.length
```

### Update Frequency
- **Every 7 days**: Complete refresh of all 6 reviews
- **Automatic**: No manual intervention required
- **Predictable**: Same content for the same week globally

## Benefits

### 🎯 **For Users**
- **Fresh content**: Always see recent-looking reviews
- **Authentic feel**: Realistic names, dates, and content
- **Engaging**: Varied experiences and perspectives

### 🔧 **For Developers**
- **Zero maintenance**: Fully automated system
- **Scalable**: Easy to add more names/reviews to pools
- **Reliable**: Deterministic output based on time

### 📈 **For Business**
- **SEO benefits**: Fresh content signals to search engines
- **User trust**: Recent reviews build confidence
- **Professional appearance**: Always looks active and current

## Customization

### Adding More Names
Add to the `reviewerNames` array in `generateDynamicReviews()` function.

### Adding More Reviews
Add to the `reviewTexts` array in `generateDynamicReviews()` function.

### Changing Update Frequency
Modify the week calculation:
- Daily: `Math.floor(currentDate.getTime() / (24 * 60 * 60 * 1000))`
- Monthly: `Math.floor(currentDate.getTime() / (30 * 24 * 60 * 60 * 1000))`

## Example Output

**Week 1:**
- Amit Sharma (3 days ago) - 4 stars
- Priya Patel (1 week ago) - 4 stars
- Rajesh Kumar (5 weeks ago) - 5 stars

**Week 2:**
- Meera Desai (7 days ago) - 4 stars
- Vikram Singh (2 weeks ago) - 4 stars
- Kavita Reddy (4 weeks ago) - 5 stars

The system ensures your website always appears active with fresh, authentic-looking reviews that update automatically every week!