import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link } from 'react-router-dom';
import { ChevronLeft, ChevronRight, ArrowRight, BookOpen } from 'lucide-react';

const slides = [
  {
    id: 1,
    image: '/hero_students_v1.png',
    title: 'Shaping Future Leaders',
    highlight: 'Through Excellence',
    subtitle: 'A tradition of academic rigor combined with modern innovation. Discover a nurturing environment where your child can truly thrive.',
    primaryCta: 'Apply Now',
    primaryLink: '/admissions',
    secondaryCta: 'Explore Schools',
    secondaryLink: '/schools'
  },
  {
    id: 2,
    image: 'https://images.unsplash.com/photo-1577896851231-70ef18881754?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
    title: 'State-of-the-Art',
    highlight: 'Smart Classrooms',
    subtitle: 'Step into the future of learning with fully digital interactive boards, AI-assisted learning tools, and global connectivity.',
    primaryCta: 'View Facilities',
    primaryLink: '/facilities',
    secondaryCta: 'Our Vision',
    secondaryLink: '/about'
  },
  {
    id: 3,
    image: 'https://images.unsplash.com/photo-1546410531-bea4f4b971a8?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
    title: 'Beyond Academics:',
    highlight: 'Sports & Arts',
    subtitle: 'We believe in holistic growth. From national-level sports complexes to dedicated performing arts theaters.',
    primaryCta: 'Student Life',
    primaryLink: '/academics',
    secondaryCta: 'Latest News',
    secondaryLink: '/news'
  },
  {
    id: 4,
    image: 'https://images.unsplash.com/photo-1509062522246-3755977927d7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
    title: 'Admissions Open',
    highlight: '2026-2027 Cohort',
    subtitle: 'Secure your child\'s future. We are currently accepting applications for all grades across our three premium campuses.',
    primaryCta: 'Start Admission',
    primaryLink: '/admissions',
    secondaryCta: 'Contact Us',
    secondaryLink: '/contact'
  }
];

export default function Hero() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const [isHovered, setIsHovered] = useState(false);

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
      className="relative min-h-[500px] h-screen flex flex-col items-center justify-center overflow-hidden bg-brand-primary group pt-24 lg:pt-32"
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
          className="absolute inset-0 z-0 bg-cover bg-center bg-no-repeat opacity-40 mix-blend-overlay"
          style={{ backgroundImage: `url("${slides[currentSlide].image}")` }}
        />
      </AnimatePresence>

      <div className="absolute inset-0 z-0 bg-gradient-to-t from-brand-primary via-brand-primary/60 to-transparent" />

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

      {/* Content */}
      <div className="relative z-10 w-full max-w-7xl mx-auto px-4 md:px-16 text-center flex-grow flex items-center justify-center py-4">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentSlide}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.6, ease: "easeOut" }}
            className="space-y-4 md:space-y-8"
          >
            <h1 className="text-[clamp(1.5rem,7vh,4rem)] font-serif font-bold text-white tracking-tight leading-[1.05]">
              {slides[currentSlide].title} <br className="hidden md:block" />
              <span className="text-brand-accent">{slides[currentSlide].highlight}</span>
            </h1>
           
            <p className="max-w-2xl mx-auto text-base md:text-xl text-gray-200 leading-relaxed px-4">
              {slides[currentSlide].subtitle}
            </p>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-8">
              <Link 
                to={slides[currentSlide].primaryLink}
                className="group/btn flex items-center gap-2 bg-brand-accent text-white px-8 py-4 rounded-full font-medium transition-all hover:opacity-90 hover:scale-105 active:scale-100 shadow-lg shadow-brand-accent/20"
              >
                {slides[currentSlide].primaryCta}
                <ArrowRight className="w-4 h-4 transition-transform group-hover/btn:translate-x-1" />
              </Link>
              
              <Link 
                to={slides[currentSlide].secondaryLink}
                className="group/btn flex items-center gap-2 bg-white/10 text-white px-8 py-4 rounded-full font-medium backdrop-blur-md border border-white/20 transition-all hover:bg-white/20"
              >
                <BookOpen className="w-4 h-4" />
                {slides[currentSlide].secondaryCta}
              </Link>
            </div>
          </motion.div>
        </AnimatePresence>
      </div>

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
