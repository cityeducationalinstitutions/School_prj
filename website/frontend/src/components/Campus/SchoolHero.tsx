import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';

export default function SchoolHero({ 
  campusName = "City Talent",
  description = "We focus on shaping futures through quality education, holistic student development, and a positive, inclusive environment where every child thrives.",
  image = "https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80"
}: { 
  campusName?: string;
  description?: string;
  image?: string;
}) {
  return (
    <section className="relative min-h-[500px] h-screen max-h-[850px] flex items-center overflow-hidden bg-brand-light pt-[80px] lg:pt-[108px]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
          
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="flex flex-col space-y-8 z-10"
          >
            <div>
              <span className="text-xs font-bold tracking-[0.2em] text-gray-500 uppercase mb-4 block">{campusName} Campus</span>
              <h1 className="text-[clamp(1.75rem,7vh,4.5rem)] text-brand-primary font-serif font-bold leading-[1.05] tracking-tighter mb-6">
                {campusName} <br/>
                <span className="text-brand-accent drop-shadow-sm leading-tight">Campus.</span>
              </h1>
            </div>
            
            <p className="text-lg md:text-xl text-gray-600 max-w-lg leading-relaxed">
              {description}
            </p>

            <div className="flex gap-4 pt-4">
              <Link to="/admissions">
                <button className="px-8 py-4 bg-brand-accent text-white text-sm font-bold tracking-widest uppercase hover:-translate-y-1 hover:shadow-xl hover:shadow-brand-accent/20 hover:bg-brand-primary transition-all duration-300">
                  Admissions
                </button>
              </Link>
              <Link to="/academics">
                <button className="px-8 py-4 bg-brand-accent text-white text-sm font-bold tracking-widest uppercase hover:-translate-y-1 hover:shadow-xl hover:shadow-brand-accent/20 hover:bg-brand-primary transition-all duration-300">
                  Academics
                </button>
              </Link>
            </div>
          </motion.div>

          <motion.div 
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 1, delay: 0.2 }}
            className="relative h-[45vh] lg:h-[60vh] w-full hidden md:block"
          >
            <div className="absolute inset-0 bg-white rounded-2xl overflow-hidden shadow-2xl">
              <img 
                src={image} 
                alt={`${campusName} Campus`} 
                className="w-full h-full object-cover transition-transform duration-1000 hover:scale-110 scale-[1.12]"
              />
            </div>
          </motion.div>

        </div>
      </div>
    </section>
  );
}
