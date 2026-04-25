import { motion } from 'framer-motion';
import { Quote } from 'lucide-react';

const LeadershipSection = () => {
  return (
    <section className="py-24 bg-brand-primary text-white relative overflow-hidden">
      {/* Decorative Accents */}
      <div className="absolute top-0 right-0 w-96 h-96 bg-brand-accent/5 rounded-full blur-[100px] -translate-y-1/2 translate-x-1/2"></div>
      <div className="absolute bottom-0 left-0 w-64 h-64 bg-brand-secondary/10 rounded-full blur-[80px] translate-y-1/2 -translate-x-1/2"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <Quote className="w-12 h-12 sm:w-16 sm:h-16 text-brand-accent mx-auto mb-6 sm:mb-10 opacity-40" />
            <h2 className="text-2xl md:text-5xl font-serif leading-tight mb-12 px-2">
              "Our commitment is to empower every child with the knowledge, values, and skills required to navigate a complex world with wisdom and integrity."
            </h2>
            <div className="flex flex-col items-center">
              <div className="w-20 h-20 rounded-full border-2 border-brand-accent p-1 mb-6">
                <div className="w-full h-full rounded-full bg-brand-accent/20 flex items-center justify-center font-serif text-2xl font-bold">
                  CEI
                </div>
              </div>
              <div className="text-xl font-bold tracking-wide">The Board of Directors</div>
              <div className="text-brand-accent text-sm uppercase tracking-widest font-bold mt-2">City Educational Institutions</div>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default LeadershipSection;
