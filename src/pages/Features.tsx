import React from 'react'
import { 
  WifiIcon, 
  TruckIcon, 
  HomeIcon,
  BuildingOffice2Icon,
  SparklesIcon,
  ShieldCheckIcon,
  ClockIcon,
  UserGroupIcon
} from '@heroicons/react/24/outline'
import SEO from '../components/SEO'

const Features: React.FC = () => {
  const features = [
    {
      icon: WifiIcon,
      title: 'Free Wi-Fi',
      description: 'High-speed internet connectivity throughout the resort for all your digital needs.'
    },
    {
      icon: TruckIcon,
      title: 'Free Parking',
      description: 'Complimentary parking space for all guests with 24/7 security surveillance.'
    },
    {
      icon: BuildingOffice2Icon,
      title: 'Swimming Pool',
      description: 'Outdoor swimming pool with stunning valley views, perfect for relaxation.'
    },
    {
      icon: HomeIcon,
      title: 'Spacious Rooms',
      description: 'Well-appointed rooms with modern amenities and breathtaking valley views.'
    },
    {
      icon: SparklesIcon,
      title: 'Housekeeping',
      description: 'Daily housekeeping service to ensure your stay is comfortable and clean.'
    },
    {
      icon: ShieldCheckIcon,
      title: '24/7 Security',
      description: 'Round-the-clock security service for your safety and peace of mind.'
    },
    {
      icon: ClockIcon,
      title: 'Room Service',
      description: 'In-room dining service available to make your stay more convenient.'
    },
    {
      icon: UserGroupIcon,
      title: 'Event Spaces',
      description: 'Perfect venues for weddings, corporate events, and family gatherings.'
    }
  ]

  return (
    <>
      <SEO 
        title="Resort Features & Amenities - Kondan The Retreat"
        description="Discover the premium features and amenities at Kondan The Retreat. From free Wi-Fi and parking to swimming pool and 24/7 security, we ensure a comfortable stay."
        keywords="resort features, amenities, Kondan The Retreat, Maval resort, luxury amenities"
      />
      
      <div className="bg-cream-beige min-h-screen">
        {/* Hero Section */}
        <div className="relative bg-gradient-to-r from-forest-800 to-ocean-800 text-white py-20">
          <div className="absolute inset-0 bg-black/20"></div>
          <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold mb-6">
              Resort Features & Amenities
            </h1>
            <p className="text-xl sm:text-2xl text-white/90 max-w-3xl mx-auto">
              Experience luxury and comfort with our comprehensive range of premium amenities designed for your perfect getaway.
            </p>
          </div>
        </div>

        {/* Features Grid */}
        <div className="py-16 sm:py-20 lg:py-24">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h2 className="text-3xl sm:text-4xl font-bold text-forest-800 mb-4">
                Premium Amenities
              </h2>
              <p className="text-lg text-gray-600 max-w-2xl mx-auto">
                Managed by Stay Nature, we provide world-class facilities to ensure your stay is memorable and comfortable.
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
              {features.map((feature, index) => (
                <div 
                  key={index}
                  className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-shadow duration-300 text-center"
                >
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-forest-100 rounded-full mb-4">
                    <feature.icon className="w-8 h-8 text-forest-600" />
                  </div>
                  <h3 className="text-xl font-semibold text-gray-900 mb-3">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600 leading-relaxed">
                    {feature.description}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Additional Services Section */}
        <div className="bg-white py-16 sm:py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-12">
              <h2 className="text-3xl sm:text-4xl font-bold text-forest-800 mb-4">
                Additional Services
              </h2>
              <p className="text-lg text-gray-600">
                We go the extra mile to make your stay exceptional
              </p>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
              <div className="space-y-6">
                <div className="flex items-start space-x-4">
                  <div className="flex-shrink-0 w-6 h-6 bg-forest-500 rounded-full flex items-center justify-center mt-1">
                    <div className="w-2 h-2 bg-white rounded-full"></div>
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Restaurant & Dining</h3>
                    <p className="text-gray-600">Multi-cuisine restaurant serving delicious local and international dishes with valley views.</p>
                  </div>
                </div>

                <div className="flex items-start space-x-4">
                  <div className="flex-shrink-0 w-6 h-6 bg-forest-500 rounded-full flex items-center justify-center mt-1">
                    <div className="w-2 h-2 bg-white rounded-full"></div>
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Travel Assistance</h3>
                    <p className="text-gray-600">Local sightseeing arrangements and travel assistance to explore nearby attractions.</p>
                  </div>
                </div>

                <div className="flex items-start space-x-4">
                  <div className="flex-shrink-0 w-6 h-6 bg-forest-500 rounded-full flex items-center justify-center mt-1">
                    <div className="w-2 h-2 bg-white rounded-full"></div>
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Laundry Service</h3>
                    <p className="text-gray-600">Professional laundry and dry cleaning services for your convenience.</p>
                  </div>
                </div>

                <div className="flex items-start space-x-4">
                  <div className="flex-shrink-0 w-6 h-6 bg-forest-500 rounded-full flex items-center justify-center mt-1">
                    <div className="w-2 h-2 bg-white rounded-full"></div>
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Conference Facilities</h3>
                    <p className="text-gray-600">Well-equipped meeting rooms and conference facilities for corporate events.</p>
                  </div>
                </div>
              </div>

              <div className="relative">
                <img
                  src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600"
                  alt="Resort Amenities"
                  className="w-full h-96 object-cover rounded-2xl shadow-lg"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent rounded-2xl"></div>
              </div>
            </div>
          </div>
        </div>

        {/* Call to Action */}
        <div className="bg-forest-800 text-white py-16">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 className="text-3xl sm:text-4xl font-bold mb-6">
              Ready to Experience Luxury?
            </h2>
            <p className="text-xl text-white/90 mb-8">
              Book your stay at Kondan The Retreat and enjoy all these premium amenities and more.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="/rooms"
                className="inline-flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-lg text-forest-800 bg-white hover:bg-gray-100 transition-colors duration-200"
              >
                View Rooms
              </a>
              <a
                href="/contact"
                className="inline-flex items-center justify-center px-8 py-3 border-2 border-white text-base font-medium rounded-lg text-white hover:bg-white hover:text-forest-800 transition-colors duration-200"
              >
                Contact Us
              </a>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}

export default Features