import { motion } from 'framer-motion';

export default function ResultsSection() {
  const stats = [
    { label: "Pass Percentage", value: "100%", sub: "Last 10 Academic Years" },
    { label: "Top Percentile", value: "85%", sub: "Students above 90%" },
    { label: "Higher Ed", value: "98%", sub: "University Placement Rate" },
    { label: "Elite Scholarships", value: "150+", sub: "Awarded in Last Session" }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] px-4 sm:px-6 lg:px-8 relative overflow-hidden">
      {/* Background Graphic */}
      <div className="absolute inset-0 bg-brand-primary z-0">
        <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_center,_white_1px,_transparent_1px)] bg-[length:32px_32px]"></div>
        <div className="absolute bottom-0 right-0 w-[800px] h-[800px] bg-white/5 rounded-full blur-[150px] -z-10 translate-x-1/2"></div>
      </div>

      <div className="max-w-7xl mx-auto relative z-10">
        <div className="text-center mb-20">
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold text-white tracking-tighter mb-4">
            Legacy of <span className="text-brand-accent italic font-light">Excellence</span>
          </h2>
          <p className="text-white/60 font-light max-w-xl mx-auto italic">
            Numbers that define our dedication to academic rigor and student achievement.
          </p>
        </div>

        <div className="grid grid-cols-2 lg:grid-cols-4 gap-12 lg:gap-8">
          {stats.map((stat, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, scale: 0.9 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: idx * 0.1 }}
              className="group text-center"
            >
              <div className="mb-6 relative">
                <div className="text-6xl md:text-7xl font-serif font-bold text-white group-hover:text-brand-accent transition-colors duration-500 tracking-tighter">
                  {stat.value}
                </div>
                <div className="absolute -inset-4 border border-white/5 rounded-2xl group-hover:border-brand-accent/20 transition-all duration-500 -z-10"></div>
              </div>
              <p className="text-white font-bold uppercase tracking-[0.2em] text-[10px] mb-2">{stat.label}</p>
              <p className="text-white/40 text-xs font-light tracking-wide">{stat.sub}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
