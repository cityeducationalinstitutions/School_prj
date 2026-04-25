import { motion } from 'framer-motion';
import { Quote } from 'lucide-react';

export default function PrincipalMessage({ 
  campusName = "City Talent",
  principalName = "Dr. Anjali Verma",
  principalImage = "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=800",
  principalQuote = "At City Talent, we see beauty in every child's potential. Our mission is to provide the canvas upon which they can paint their future with confidence and integrity."
}: { 
  campusName?: string;
  principalName?: string;
  principalImage?: string;
  principalQuote?: string;
}) {
  return (
    <section className="relative py-[clamp(4rem,10vh,8rem)] bg-transparent overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 translate-x-1/3 -translate-y-1/3 opacity-60"></div>
      <div className="absolute bottom-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-brand-accent/20 to-transparent -z-10"></div>

      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="glass-card rounded-[3rem] p-10 md:p-20 relative overflow-hidden border border-white">
          {/* Large Floating Quote Mark */}
          <div className="absolute top-10 left-10 text-brand-accent/10 pointer-events-none">
            <Quote size={180} strokeWidth={0.5} />
          </div>

          <div className="relative z-10 flex flex-col lg:flex-row gap-16 items-center">
            
            <motion.div 
              initial={{ opacity: 0, scale: 0.9, rotate: -2 }}
              whileInView={{ opacity: 1, scale: 1, rotate: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 1, ease: "easeOut" }}
              className="relative shrink-0"
            >
              {/* Premium Dual Border Frame */}
              <div className="absolute -inset-4 border border-brand-accent/20 rounded-[4rem] -z-10"></div>
              
              <div className="w-64 h-80 md:w-80 md:h-[28rem] rounded-[3.5rem] overflow-hidden border-8 border-white shadow-2xl">
                <img 
                  src={principalImage} 
                  alt="Principal" 
                  className="w-full h-full object-cover transform transition-transform duration-700 hover:scale-105"
                />
              </div>

              {/* Decorative signature-like name badge */}
              <div className="absolute -bottom-8 -left-8 bg-brand-primary text-white py-6 px-10 rounded-[2rem] shadow-2xl hidden md:block">
                <div className="text-2xl font-serif italic text-brand-accent mb-1 leading-none">{principalName}</div>
                <div className="text-[10px] font-bold tracking-[0.3em] uppercase opacity-70">Principal, CEI</div>
              </div>
            </motion.div>

            <motion.div 
              initial={{ opacity: 0, x: 30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 1, delay: 0.2 }}
              className="flex-1 space-y-10"
            >
              <div className="space-y-4">
                <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block">Leadership Voice</span>
                <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary tracking-tighter leading-[1.1]">
                  A Message from our <br />
                  <span className="text-brand-accent drop-shadow-sm">Principal.</span>
                </h2>
                <div className="w-16 h-1 bg-brand-accent rounded-full mt-6 mb-10"></div>
                <p className="text-xl md:text-2xl text-gray-600 leading-relaxed">
                  “{principalQuote}”
                </p>
              </div>
              
              <div className="pt-4 md:hidden">
                <div className="font-bold text-brand-primary font-serif text-2xl">{principalName}</div>
                <div className="text-[10px] font-bold tracking-[0.3em] text-gray-400 uppercase mt-2">Principal, {campusName} Campus</div>
              </div>

              {/* Institutional Values Badge */}
              <div className="flex gap-8 pt-4 opacity-50 grayscale hover:grayscale-0 transition-all duration-500 hidden md:flex">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-brand-accent/10 flex items-center justify-center">
                    <div className="w-2 h-2 rounded-full bg-brand-accent"></div>
                  </div>
                  <span className="text-[10px] font-bold tracking-widest uppercase">Character</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-brand-accent/10 flex items-center justify-center">
                    <div className="w-2 h-2 rounded-full bg-brand-accent"></div>
                  </div>
                  <span className="text-[10px] font-bold tracking-widest uppercase">Excellence</span>
                </div>
              </div>
            </motion.div>

          </div>
        </div>
      </div>
    </section>
  );
}
