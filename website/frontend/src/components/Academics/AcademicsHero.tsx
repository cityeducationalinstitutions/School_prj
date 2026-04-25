import { motion } from 'framer-motion';

export default function AcademicsHero() {
  return (
    <section className="relative pt-16 pb-12 px-4 sm:px-6 lg:px-8 overflow-hidden bg-brand-light flex items-center min-h-[400px] h-[55vh] max-h-[650px]">
      <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 hidden sm:block"></div>
      
      <div className="max-w-7xl mx-auto text-center relative z-10">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8 }}
        >
          <span className="inline-block py-1.5 px-5 rounded-full border border-brand-accent/30 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-8">
            Excellence in Learning
          </span>
          <h1 className="text-[clamp(1.75rem,7vh,4.5rem)] font-serif font-bold text-brand-primary tracking-tighter leading-[0.9] mb-10">
            Academy of <br />
            <span className="text-brand-accent italic font-light">Structure & Growth</span>
          </h1>
          <p className="max-w-3xl mx-auto text-gray-500 font-light text-[clamp(1rem,2vh,1.5rem)] leading-relaxed">
            Our academic framework is designed to spark intellectual curiosity while maintaining a rigorous focus on core mastery and character development.
          </p>
        </motion.div>
      </div>

      {/* Decorative Wave or Line */}
      <div className="absolute bottom-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-brand-primary/10 to-transparent"></div>
    </section>
  );
}
