import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Maximize2, Filter } from 'lucide-react';

const CATEGORIES = [
  'All',
  'Sports',
  'Events',
  'School Functions',
  'Academic Activities',
  'Yoga & Wellness'
];
const GALLERY_ITEMS = [
  { id: 13, category: 'Academic Activities', title: 'Traffic Rules Awareness', image: '/traffic_rules_activity.png' },
  { id: 1, category: 'Sports', title: 'Annual Athletics Meet', image: 'https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?q=80&w=1200' },
  { id: 2, category: 'Academic Activities', title: 'Science Exhibition 2024', image: 'https://images.unsplash.com/photo-1564981797816-1043664bf78d?q=80&w=1200' },
  { id: 3, category: 'Yoga & Wellness', title: 'International Yoga Day', image: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=1200' },
  { id: 4, category: 'Events', title: 'Cultural Fest Celebrations', image: 'https://images.unsplash.com/photo-1511578314322-379afb476865?q=80&w=1200' },
  { id: 5, category: 'School Functions', title: 'Investiture Ceremony', image: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=1200' },
  { id: 6, category: 'Sports', title: 'Inter-School Basketball', image: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1200' },
  { id: 7, category: 'Academic Activities', title: 'Interactive Learning Session', image: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=1200' },
  { id: 8, category: 'Events', title: 'Republic Day Parade', image: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=1200' },
  { id: 9, category: 'Academic Activities', title: 'Robotics Workshop', image: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=1200' },
  { id: 10, category: 'Yoga & Wellness', title: 'Mindfulness Session', image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=1200' },
  { id: 11, category: 'Sports', title: 'Cricket Tournament', image: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?q=80&w=1200' },
  { id: 12, category: 'School Functions', title: 'Annual Day Performance', image: 'https://images.unsplash.com/photo-1459749411177-042180ce6742?q=80&w=1200' },
];

export default function Gallery() {
  const [activeTab, setActiveTab] = useState('All');
  const [filteredItems, setFilteredItems] = useState(GALLERY_ITEMS);
  const [visibleCount, setVisibleCount] = useState(8);

  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  useEffect(() => {
    if (activeTab === 'All') {
      setFilteredItems(GALLERY_ITEMS);
    } else {
      setFilteredItems(GALLERY_ITEMS.filter(item => item.category === activeTab));
    }
    setVisibleCount(8); // Reset count on tab change
  }, [activeTab]);

  return (
    <div className="bg-white min-h-screen pt-[108px] pb-24">
      {/* Hero Header */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center mb-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="text-4xl md:text-6xl font-serif font-bold text-brand-primary mb-4 tracking-tight">
            School <span className="text-brand-accent italic">Gallery</span>
          </h1>
          <p className="text-gray-500 text-lg max-w-2xl mx-auto font-light leading-relaxed">
            A visual journey through the vibrant life, achievements, and memorable moments at City Educational Institutions.
          </p>
        </motion.div>
      </section>

      {/* Filter Tabs */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-12">
        <div className="flex flex-wrap justify-center gap-3">
          {CATEGORIES.map((cat) => (
            <button
              key={cat}
              onClick={() => setActiveTab(cat)}
              className={`px-6 py-2.5 rounded-full text-sm font-bold tracking-wide transition-all duration-300 ${
                activeTab === cat
                  ? 'bg-brand-accent text-white shadow-lg shadow-brand-accent/30'
                  : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </section>

      {/* Gallery Grid */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <AnimatePresence mode='popLayout'>
            {filteredItems.slice(0, visibleCount).map((item, idx) => (
              <motion.div
                layout
                key={item.id}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.9 }}
                transition={{ duration: 0.4, delay: idx * 0.05 }}
                className="group relative aspect-video bg-gray-100 rounded-[1.5rem] overflow-hidden shadow-sm hover:shadow-xl transition-all duration-500"
              >
                <img 
                  src={item.image} 
                  alt={item.title} 
                  className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                />
                
                {/* Hover Overlay */}
                <div className="absolute inset-0 bg-brand-primary/80 opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex flex-col items-center justify-center p-6 text-center">
                  <div className="mb-4 transform translate-y-4 group-hover:translate-y-0 transition-transform duration-500">
                    <Maximize2 className="w-8 h-8 text-brand-accent" />
                  </div>
                  <h3 className="text-white font-serif font-bold text-lg mb-1 transform translate-y-4 group-hover:translate-y-0 transition-transform duration-500 delay-75">
                    {item.title}
                  </h3>
                  <p className="text-brand-accent/80 text-[10px] font-black tracking-[0.2em] uppercase transform translate-y-4 group-hover:translate-y-0 transition-transform duration-500 delay-100">
                    {item.category}
                  </p>
                </div>
              </motion.div>
            ))}
          </AnimatePresence>
        </div>

        {/* Load More Button */}
        {visibleCount < filteredItems.length && (
          <div className="mt-20 text-center">
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setVisibleCount(prev => prev + 4)}
              className="px-10 py-4 bg-brand-accent text-white font-bold text-xs tracking-[0.3em] uppercase rounded-full shadow-xl shadow-brand-accent/20 hover:bg-brand-accent/90 transition-all"
            >
              Load More
            </motion.button>
          </div>
        )}
      </section>
    </div>
  );
}
