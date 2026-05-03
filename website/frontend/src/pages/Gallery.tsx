import { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Maximize2, Upload, Image as ImageIcon, Trash2 } from 'lucide-react';

const CATEGORIES = [
  'All',
  'Sports',
  'Events',
  'School Functions',
  'Academic Activities',
  'Yoga & Wellness'
];

const INITIAL_GALLERY_ITEMS = [
  { id: 1, category: 'Academic Activities', title: 'Traffic Rules Awareness', image: '/traffic_rules_activity.jpeg' },
  { id: 2, category: 'Yoga & Wellness', title: 'Morning Yoga Session', image: '/yoga_session_1.png' },
  { id: 3, category: 'Yoga & Wellness', title: 'Advanced Poses Workshop', image: '/yoga_session_2.png' },
  { id: 4, category: 'Yoga & Wellness', title: 'International Yoga Day - Mass Session', image: '/yoga_mass_1.png' },
  { id: 5, category: 'Yoga & Wellness', title: 'Outdoor Wellness Drive', image: '/yoga_mass_2.jpeg' },
  { id: 6, category: 'Yoga & Wellness', title: 'Mindfulness & Meditation', image: '/yoga_session_3.jpg' },
];

export default function Gallery() {
  const [activeTab, setActiveTab] = useState('All');
  const [galleryItems, setGalleryItems] = useState(INITIAL_GALLERY_ITEMS);
  const [visibleCount, setVisibleCount] = useState(8);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Load persistent items on mount
  useEffect(() => {
    window.scrollTo(0, 0);
    const savedItems = localStorage.getItem('school_gallery_uploads');
    if (savedItems) {
      try {
        const parsedItems = JSON.parse(savedItems);
        setGalleryItems([...parsedItems, ...INITIAL_GALLERY_ITEMS]);
      } catch (e) {
        console.error("Failed to load saved gallery items", e);
      }
    }
  }, []);

  const filteredItems = activeTab === 'All' 
    ? galleryItems 
    : galleryItems.filter(item => item.category === activeTab);

  const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (files && files[0]) {
      const file = files[0];
      
      const reader = new FileReader();
      reader.onloadend = () => {
        const base64String = reader.result as string;
        
        const newItem = {
          id: Date.now(),
          category: activeTab === 'All' ? 'Events' : activeTab,
          title: `Uploaded: ${file.name.split('.')[0]}`,
          image: base64String
        };

        setGalleryItems(prev => [newItem, ...prev]);
        
        // Persist to local storage
        const currentUploads = JSON.parse(localStorage.getItem('school_gallery_uploads') || '[]');
        localStorage.setItem('school_gallery_uploads', JSON.stringify([newItem, ...currentUploads]));
      };
      reader.readAsDataURL(file);
    }
  };
  const handleDeleteItem = (id: number | string) => {
    // Remove from state
    setGalleryItems(prev => prev.filter(item => item.id !== id));
    
    // Remove from local storage if it's an upload
    const currentUploads = JSON.parse(localStorage.getItem('school_gallery_uploads') || '[]');
    const updatedUploads = currentUploads.filter((item: any) => item.id !== id);
    localStorage.setItem('school_gallery_uploads', JSON.stringify(updatedUploads));
  };

  return (
    <div className="bg-white min-h-screen pt-[108px] pb-24">
      {/* Hidden File Input */}
      <input 
        type="file" 
        ref={fileInputRef}
        onChange={handleFileUpload}
        accept="image/*"
        className="hidden"
      />

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
          <p className="text-gray-500 text-lg max-w-2xl mx-auto font-light leading-relaxed mb-8">
            A visual journey through the vibrant life, achievements, and memorable moments at City Educational Institutions.
          </p>

          {/* Dynamic Upload Button */}
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => fileInputRef.current?.click()}
            className="inline-flex items-center gap-3 px-8 py-3.5 bg-brand-primary text-white font-bold text-xs tracking-widest uppercase rounded-full shadow-2xl shadow-brand-primary/20 hover:bg-brand-primary/90 transition-all"
          >
            <Upload className="w-4 h-4 text-brand-accent" />
            Upload to {activeTab === 'All' ? 'Gallery' : activeTab}
          </motion.button>
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
        {filteredItems.length > 0 ? (
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
                  className="group relative aspect-square bg-gray-50 rounded-[1.5rem] overflow-hidden shadow-sm hover:shadow-xl transition-all duration-500"
                >
                  <img 
                    src={item.image} 
                    alt={item.title} 
                    className="w-full h-full object-contain p-2 transition-transform duration-700 group-hover:scale-105"
                  />
                  
                  {/* Hover Overlay */}
                  <div className="absolute inset-0 bg-brand-primary/80 opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex flex-col items-center justify-center p-6 text-center">
                    <div className="flex gap-4 mb-4 transform translate-y-4 group-hover:translate-y-0 transition-transform duration-500">
                      <div className="p-2 bg-white/10 rounded-full hover:bg-brand-accent transition-colors cursor-pointer">
                        <Maximize2 className="w-5 h-5 text-white" />
                      </div>
                      <button 
                        onClick={(e) => {
                          e.stopPropagation();
                          handleDeleteItem(item.id);
                        }}
                        className="p-2 bg-white/10 rounded-full hover:bg-red-500 transition-colors cursor-pointer"
                        title="Delete Image"
                      >
                        <Trash2 className="w-5 h-5 text-white" />
                      </button>
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
        ) : (
          <div className="text-center py-20 bg-gray-50 rounded-[3rem] border-2 border-dashed border-gray-200">
            <ImageIcon className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-400 font-medium">No images in this category yet.</p>
          </div>
        )}

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
