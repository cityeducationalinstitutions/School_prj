import { motion } from 'framer-motion';
import { Check } from 'lucide-react';

export default function TeachingApproach() {
  const points = [
    "Concept-based Learning",
    "Activity-based Pedagogies",
    "Student Participation & Peer Learning",
    "Continuous & Comprehensive Evaluation"
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-white px-4 sm:px-6 lg:px-8 relative overflow-hidden">
      <div className="absolute top-1/2 left-0 -translate-y-1/2 w-[600px] h-[600px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 opacity-60 hidden sm:block"></div>
      
      <div className="max-w-7xl mx-auto">
        <div className="grid lg:grid-cols-2 gap-20 items-center">
          
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="space-y-10"
          >
            <div>
              <span className="inline-block py-1.5 px-5 rounded-full border border-brand-accent/30 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-8">
                Our Pedagogy
              </span>
              <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold text-brand-primary tracking-tighter leading-none mb-8">
                The Way We <br />
                <span className="text-brand-accent italic font-light">Teach & Inspire</span>
              </h2>
              <p className="text-gray-500 font-light text-xl leading-relaxed italic">
                Our teachers don't just deliver content; they facilitate discovery. We ensure every lesson connects to the child's context and future ambition.
              </p>
            </div>

            <div className="space-y-6">
              {points.map((point, idx) => (
                <div key={idx} className="flex items-center gap-5 p-5 glass-card rounded-2xl bg-brand-light/50 border-white/60 hover:translate-x-4 transition-transform duration-500 cursor-default">
                  <div className="w-8 h-8 rounded-lg bg-brand-accent flex items-center justify-center shadow-lg shadow-brand-accent/20 shrink-0">
                    <Check className="w-5 h-5 text-white" />
                  </div>
                  <span className="text-lg font-bold text-brand-primary uppercase tracking-wider text-[11px]">{point}</span>
                </div>
              ))}
            </div>
          </motion.div>

          {/* Right Image with Decorative Frame */}
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="relative"
          >
            <div className="relative z-10 aspect-square rounded-[2rem] sm:rounded-[3.5rem] overflow-hidden shadow-elite border-4 sm:border-8 border-white">
              <img 
                src="/academics_students.png" 
                alt="Students collaborating" 
                className="w-full h-full object-cover"
              />
            </div>
            {/* Geometric Decors */}
            <div className="absolute -top-10 -right-10 w-40 h-40 border-t-8 border-r-8 border-brand-accent/10 rounded-[3rem] -z-10"></div>
            <div className="absolute -bottom-10 -left-10 w-40 h-40 border-b-8 border-l-8 border-brand-primary/10 rounded-[3rem] -z-10"></div>
          </motion.div>

        </div>
      </div>
    </section>
  );
}
