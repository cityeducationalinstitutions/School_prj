import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link } from 'react-router-dom';
import { ChevronLeft, ChevronRight, ArrowRight, BookOpen } from 'lucide-react';

const slides = [
  {
    id: 1,
    image: '/hero_main_v4.png',
    mobileImage: '/hero_main_v4.png',
    title: 'Shaping Future Leaders',
    highlight: 'Through Excellence',
    subtitle: 'A tradition of academic rigor combined with modern innovation. Discover a nurturing environment where your child can truly thrive.',
    primaryCta: 'Apply Now',
    primaryLink: '/admissions',
    secondaryCta: 'Explore Schools',
    secondaryLink: '/schools',
    fit: 'cover'
  },
  {
    id: 2,
    image: '/hero_elite_v2.png',
    mobileImage: '/hero_elite_v2.png',
    title: 'State-of-the-Art',
    highlight: 'Smart Classrooms',
    subtitle: 'Step into the future of learning with fully digital interactive boards, AI-assisted learning tools, and global connectivity.',
    primaryCta: 'View Facilities',
    primaryLink: '/facilities',
    secondaryCta: 'Our Vision',
    secondaryLink: '/about',
    fit: 'cover'
  },
  {
    id: 3,
    image: 'https://images.unsplash.com/photo-1523050335102-c884af17d274?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
    mobileImage: 'https://images.unsplash.com/photo-1523050335102-c884af17d274?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
    title: 'Beyond Academics:',
    highlight: 'Sports & Arts',
    subtitle: 'We believe in holistic growth. From national-level sports complexes to dedicated performing arts theaters.',
    primaryCta: 'Student Life',
    primaryLink: '/academics',
    secondaryCta: 'Latest News',
    secondaryLink: '/news',
    fit: 'cover'
  },
  {
    id: 4,
    image: '/hero_achievements_v3.png',
    mobileImage: '/hero_achievements_mobile.jpg',
    title: 'Admissions Open',
    highlight: '2026-2027 Cohort',
    subtitle: 'Secure your child\'s future. We are currently accepting applications for all grades across our three premium campuses.',
    primaryCta: 'Start Admission',
    primaryLink: '/admissions',
    secondaryCta: 'Contact Us',
    secondaryLink: '/contact',
    fit: 'cover'
  }
];

export default function Hero() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const [isHovered, setIsHovered] = useState(false);
  const [isMobile, setIsMobile] = useState(false);

  // Responsive check
  useEffect(() => {
    const checkMobile = () => setIsMobile(window.innerWidth < 768);
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  // Auto-scroll logic
  useEffect(() => {
    if (isHovered) return;
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % slides.length);
    }, 5000);
    return () => clearInterval(timer);
  }, [isHovered]);

  const nextSlide = () => setCurrentSlide((prev) => (prev + 1) % slides.length);
  const prevSlide = () => setCurrentSlide((prev) => (prev === 0 ? slides.length - 1 : prev - 1));
  const goToSlide = (index: number) => setCurrentSlide(index);

  return (
    <div 
      className="relative min-h-[500px] h-[calc(100vh-64px)] lg:h-[calc(100vh-96px)] xl:h-[calc(100vh-108px)] flex flex-col items-center justify-center overflow-hidden bg-black group"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <AnimatePresence mode="wait">
        <motion.div
          key={currentSlide}
          initial={{ opacity: 0, scale: 1.05 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.8, ease: "easeInOut" }}
          className="absolute inset-0 z-0 bg-cover bg-center bg-no-repeat"
          style={{ 
            backgroundImage: `url("${isMobile && (slides[currentSlide] as any).mobileImage ? (slides[currentSlide] as any).mobileImage : slides[currentSlide].image}")`
          }}
        />
      </AnimatePresence>



      {/* Navigation Arrows */}
      <button 
        onClick={prevSlide}
        className="absolute left-4 md:left-8 z-20 p-3 rounded-full bg-black/20 hover:bg-black/50 text-white backdrop-blur-sm border border-white/10 transition-all opacity-0 group-hover:opacity-100 focus:opacity-100 translate-x-4 group-hover:translate-x-0"
      >
        <ChevronLeft className="w-6 h-6" />
      </button>

      <button 
        onClick={nextSlide}
        className="absolute right-4 md:right-8 z-20 p-3 rounded-full bg-black/20 hover:bg-black/50 text-white backdrop-blur-sm border border-white/10 transition-all opacity-0 group-hover:opacity-100 focus:opacity-100 -translate-x-4 group-hover:translate-x-0"
      >
        <ChevronRight className="w-6 h-6" />
      </button>

      {/* Content Removed as per user request */}

      {/* Dot Indicators - Locked to bottom */}
      <div className="absolute bottom-8 left-0 right-0 z-20 flex justify-center items-center gap-3">
        {slides.map((_, index) => (
          <button
            key={index}
            onClick={() => goToSlide(index)}
            className={`transition-all duration-300 rounded-full ${
              currentSlide === index 
                ? 'w-8 h-2 bg-brand-accent' 
                : 'w-2 h-2 bg-white/40 hover:bg-white/70'
            }`}
            aria-label={`Go to slide ${index + 1}`}
          />
        ))}
      </div>
    </div>
  );
}
