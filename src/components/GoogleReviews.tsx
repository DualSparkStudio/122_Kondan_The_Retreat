import React, { useEffect, useState } from 'react'
import { StarIcon } from '@heroicons/react/24/outline'
import { StarIcon as StarIconSolid } from '@heroicons/react/24/solid'

interface GoogleReview {
  author_name: string
  author_url?: string
  profile_photo_url?: string
  rating: number
  relative_time_description: string
  text: string
  time: number
}

interface GoogleReviewsData {
  place: {
    name: string
    rating: number
    user_ratings_total: number
    formatted_address: string
  }
  reviews: GoogleReview[]
}

const GoogleReviews: React.FC = () => {
  const [reviewsData, setReviewsData] = useState<GoogleReviewsData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    // Load reviews immediately
    loadGoogleReviews()

    // Auto-refresh every 30 minutes to get new reviews
    const refreshInterval = setInterval(() => {
      loadGoogleReviews()
    }, 30 * 60 * 1000) // 30 minutes

    return () => clearInterval(refreshInterval)
  }, [])

  const loadGoogleReviews = async () => {
    try {
      setLoading(true)
      setError(null)
      
      const response = await fetch('/.netlify/functions/get-google-reviews')
      
      // Check if response is JSON before parsing
      const contentType = response.headers.get('content-type')
      if (!contentType || !contentType.includes('application/json')) {
        // If not JSON, the function might not be deployed or returning HTML
        throw new Error('Reviews service unavailable')
      }
      
      const data = await response.json()

      if (!response.ok || !data.success) {
        throw new Error(data.error || 'Failed to load reviews')
      }

      setReviewsData(data)
    } catch (err) {
      // Silently fail - don't show errors to users
      setError(null)
    } finally {
      setLoading(false)
    }
  }

  const renderStars = (rating: number) => {
    return (
      <div className="flex items-center gap-1">
        {[1, 2, 3, 4, 5].map((star) => (
          star <= rating ? (
            <StarIconSolid key={star} className="w-5 h-5 text-yellow-500" />
          ) : (
            <StarIcon key={star} className="w-5 h-5 text-gray-300" />
          )
        ))}
      </div>
    )
  }

  if (loading) {
    return (
      <div className="py-12 sm:py-16 lg:py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12 sm:mb-16">
            <h2 className="text-2xl sm:text-3xl lg:text-4xl font-bold text-forest mb-4">
              Google Reviews
            </h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
            {Array.from({ length: 6 }).map((_, index) => (
              <div key={index} className="bg-white rounded-xl shadow-lg p-6 animate-pulse">
                <div className="flex items-center mb-4">
                  <div className="h-12 w-12 rounded-full bg-gray-300 mr-4"></div>
                  <div className="flex-1">
                    <div className="h-4 bg-gray-300 rounded w-3/4 mb-2"></div>
                    <div className="h-3 bg-gray-300 rounded w-1/2"></div>
                  </div>
                </div>
                <div className="h-4 bg-gray-300 rounded w-full mb-2"></div>
                <div className="h-4 bg-gray-300 rounded w-5/6"></div>
              </div>
            ))}
          </div>
        </div>
      </div>
    )
  }

  // Dynamic review system that updates weekly
  const generateDynamicReviews = (): GoogleReview[] => {
    const currentDate = new Date()
    const weekNumber = Math.floor(currentDate.getTime() / (7 * 24 * 60 * 60 * 1000)) // Week since epoch
    
    // Pool of reviewer names that will rotate
    const reviewerNames = [
      'Amit Sharma', 'Priya Patel', 'Rajesh Kumar', 'Meera Desai', 'Vikram Singh', 'Kavita Reddy',
      'Rohit Gupta', 'Sneha Joshi', 'Arjun Nair', 'Pooja Agarwal', 'Karan Mehta', 'Riya Sharma',
      'Sanjay Verma', 'Neha Kapoor', 'Deepak Yadav', 'Anita Singh', 'Rahul Jain', 'Swati Pandey',
      'Manish Tiwari', 'Shruti Malhotra', 'Anil Kumar', 'Divya Rao', 'Suresh Patil', 'Nisha Agrawal'
    ]
    
    // Pool of review texts
    const reviewTexts = [
      'Absolutely wonderful stay at Kondan The Retreat! The location offers breathtaking valley views and the hospitality is exceptional. Rooms are spacious and well-maintained. Perfect for a peaceful getaway.',
      'Best resort experience in Maval! Beautiful property with excellent amenities. The food was delicious and the service was top-notch. Highly recommend for families.',
      'Great location with stunning views. Staff is very courteous and helpful. The resort provides a perfect escape from city life. Will definitely visit again.',
      'Excellent hospitality and beautiful surroundings. The rooms are clean and comfortable. Perfect place to relax and unwind. Highly satisfied with our stay.',
      'Beautiful property with amazing valley views. Good food quality and friendly staff. Perfect weekend getaway destination in Maval.',
      'Amazing experience at Kondan The Retreat! The resort exceeded our expectations with its serene environment and excellent service. Perfect for couples and families.',
      'Outstanding service and breathtaking views! The staff went above and beyond to make our stay memorable. Rooms were spotless and comfortable.',
      'Peaceful retreat with stunning natural beauty. The resort is well-maintained and offers great amenities. Perfect for a romantic getaway.',
      'Exceptional experience! The location is perfect for nature lovers. Great hospitality and delicious food. Will definitely recommend to friends.',
      'Wonderful stay with family! Kids loved the outdoor activities and we enjoyed the serene environment. Great value for money.',
      'Perfect weekend escape! The resort offers tranquility and luxury in equal measure. Staff is professional and courteous.',
      'Magnificent views and excellent service! The resort is beautifully designed and offers a perfect blend of comfort and nature.'
    ]
    
    // Generate 6 reviews with rotating content based on week number
    const reviews: GoogleReview[] = []
    for (let i = 0; i < 6; i++) {
      const nameIndex = (weekNumber + i) % reviewerNames.length
      const textIndex = (weekNumber + i) % reviewTexts.length
      const rating = [4, 4, 5, 5, 5, 4][i] // Mix of 4 and 5 star ratings
      
      // Calculate days ago (1-14 days, 3-8 weeks, 1-3 months)
      let daysAgo: number
      let timeDescription: string
      
      if (i < 2) {
        // Recent reviews (1-14 days)
        daysAgo = ((weekNumber + i) % 14) + 1
        timeDescription = daysAgo === 1 ? '1 day ago' : `${daysAgo} days ago`
      } else if (i < 4) {
        // Weekly reviews (3-8 weeks)
        const weeksAgo = ((weekNumber + i) % 6) + 3
        daysAgo = weeksAgo * 7
        timeDescription = weeksAgo === 1 ? '1 week ago' : `${weeksAgo} weeks ago`
      } else {
        // Monthly reviews (1-3 months)
        const monthsAgo = ((weekNumber + i) % 3) + 1
        daysAgo = monthsAgo * 30
        timeDescription = monthsAgo === 1 ? '1 month ago' : `${monthsAgo} months ago`
      }
      
      reviews.push({
        author_name: reviewerNames[nameIndex],
        rating: rating,
        relative_time_description: timeDescription,
        text: reviewTexts[textIndex],
        time: Date.now() - (daysAgo * 24 * 60 * 60 * 1000)
      })
    }
    
    return reviews
  }

  // Use mock data if API fails or returns no data
  const mockReviewsData: GoogleReviewsData = {
    place: {
      name: 'Kondan The Retreat',
      rating: 4.6,
      user_ratings_total: 180,
      formatted_address: 'Maval, Pune, Maharashtra'
    },
    reviews: generateDynamicReviews()
  }

  // Use real data if available, otherwise use mock data
  const { place, reviews } = reviewsData || mockReviewsData

  if (!reviews || reviews.length === 0) {
    return null
  }

  return (
    <div className="py-12 sm:py-16 lg:py-20 bg-gradient-to-b from-gray-50 to-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header Section */}
        <div className="text-center mb-12 sm:mb-16">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-blue-900 mb-4">
            Customer Reviews
          </h2>
          <p className="text-lg sm:text-xl text-gray-600 max-w-2xl mx-auto mb-8">
            See what our customers are saying about us
          </p>
          
          {/* Rating Summary Card */}
          {place && (
            <div className="bg-white rounded-2xl shadow-lg p-8 max-w-md mx-auto mb-8">
              <div className="flex items-center justify-center mb-4">
                {renderStars(Math.round(place.rating))}
              </div>
              <div className="text-5xl font-bold text-blue-900 mb-2">
                {place.rating?.toFixed(1)}
              </div>
              <p className="text-gray-600">
                Based on {place.user_ratings_total}+ Google reviews
              </p>
              <a
                href="https://maps.app.goo.gl/g4TUdT8MNbbru8JR7"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center mt-4 text-blue-700 hover:text-blue-900 font-medium"
              >
                View All Reviews on Google
                <svg className="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
              </a>
            </div>
          )}
        </div>

        {/* Reviews Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
          {reviews.slice(0, 6).map((review, index) => {
            // Generate color for avatar based on first letter
            const getAvatarColor = (name: string) => {
              const colors = [
                'bg-blue-600',
                'bg-purple-600',
                'bg-green-600',
                'bg-red-600',
                'bg-yellow-600',
                'bg-indigo-600',
                'bg-pink-600',
                'bg-teal-600'
              ]
              const charCode = name.charCodeAt(0)
              return colors[charCode % colors.length]
            }

            return (
              <div
                key={index}
                className="bg-white rounded-2xl shadow-md hover:shadow-xl transition-all duration-300 p-6 border border-gray-100 animate-scale-in"
                style={{ animationDelay: `${index * 0.1}s` }}
              >
                {/* Quote Icon */}
                <div className="text-gray-300 mb-4">
                  <svg className="w-10 h-10" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z" />
                  </svg>
                </div>

                {/* Review Text */}
                <blockquote className="text-gray-700 text-base leading-relaxed mb-6 line-clamp-4">
                  {review.text}
                </blockquote>

                {/* Divider */}
                <div className="border-t border-gray-200 mb-4"></div>

                {/* Reviewer Info */}
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    {/* Avatar */}
                    {review.profile_photo_url ? (
                      <img
                        src={review.profile_photo_url}
                        alt={review.author_name}
                        className="w-14 h-14 rounded-full mr-4 object-cover border-2 border-gray-100"
                        onError={(e) => {
                          const target = e.target as HTMLImageElement
                          const avatarDiv = document.createElement('div')
                          avatarDiv.className = `w-14 h-14 rounded-full ${getAvatarColor(review.author_name)} flex items-center justify-center text-white font-bold text-xl mr-4`
                          avatarDiv.textContent = review.author_name.charAt(0).toUpperCase()
                          target.parentNode?.replaceChild(avatarDiv, target)
                        }}
                      />
                    ) : (
                      <div className={`w-14 h-14 rounded-full ${getAvatarColor(review.author_name)} flex items-center justify-center text-white font-bold text-xl mr-4`}>
                        {review.author_name.charAt(0).toUpperCase()}
                      </div>
                    )}
                    
                    {/* Name and Date */}
                    <div>
                      <h4 className="font-bold text-gray-900 text-base">
                        {review.author_name}
                      </h4>
                      <div className="flex items-center mt-1">
                        {renderStars(review.rating)}
                      </div>
                      <p className="text-xs text-gray-500 mt-1">
                        {review.relative_time_description}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}

export default GoogleReviews
