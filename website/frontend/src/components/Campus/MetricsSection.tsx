import { motion } from 'framer-motion';
import { Target, History, Users, Award } from 'lucide-react';


export default function MetricsSection() {
  const metrics = [
    { value: "95%", label: "Academic Results", icon: <Target className="w-5 h-5 text-brand-accent" /> },
    { value: "10+", label: "Years Excellence", icon: <History className="w-5 h-5 text-brand-accent" /> },
    { value: "1000+", label: "Enrolled Students", icon: <Users className="w-5 h-5 text-brand-accent" /> },
    { value: "50+", label: "Expert Faculty", icon: <Award className="w-5 h-5 text-brand-accent" /> },
  ];

  return (
    <section className="relative py-4 overflow-hidden group border-y border-brand-accent/10">
      {/* Background Image with Premium Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src="/books_bg.png" 
          alt="Library Background" 
          className="w-full h-full object-cover transition-transform duration-1000"
        />
        <div className="absolute inset-0 bg-brand-accent/85 backdrop-blur-[2px]"></div>
      </div>
      
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-12 text-center py-8 md:py-10">
          {metrics.map((metric, idx) => (
            <motion.div 
              key={idx}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: idx * 0.1, duration: 0.5 }}
              className="flex flex-col items-center justify-center space-y-6"
            >
              {/* Large White Icon Container */}
              <div className="w-16 h-16 md:w-20 md:h-20 bg-white rounded-full flex items-center justify-center shadow-2xl transform transition-all duration-500">
                <div className="scale-125 md:scale-150">
                  {metric.icon}
                </div>
              </div>
 
              <div className="space-y-2">
                <div className="text-3xl md:text-5xl font-serif font-bold text-white tracking-tight">{metric.value}</div>
                <div className="text-[10px] md:text-xs font-black tracking-[0.25em] text-white/90 uppercase">{metric.label}</div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
