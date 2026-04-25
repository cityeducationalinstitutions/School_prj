import { motion } from 'framer-motion';

const TimelineSection = () => {
  const milestones = [
    {
      year: "2003",
      content: "Founding milestone with the first campus establishment and a vision for quality education",
    },
    {
      year: "2010",
      content: "Launch of specialized co-curricular programs and focused physical education tracks",
    },
    {
      year: "2015",
      content: "Expansion into a modern, fully-equipped High School facility for primary and secondary grades",
    },
    {
      year: "2021",
      content: "Integration of smart-digital tools into the SSC curriculum for enhanced student engagement",
    },
    {
      year: "2025",
      content: "Celebrating over 20 years of excellence and top SSC board results",
    }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-brand-light relative overflow-hidden">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-20">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <h2 className="text-[clamp(1.75rem,5.5vh,3.25rem)] font-serif font-bold mb-8 tracking-tighter leading-tight text-center">
              <span className="text-brand-primary">Journey of </span>
              <span className="text-brand-accent italic font-light">Academic Excellence</span>
            </h2>
            <p className="text-gray-600 text-lg md:text-xl font-medium max-w-5xl mx-auto leading-relaxed italic opacity-80">
              From its foundation, City Educational has been dedicated to building a strong academic culture 
              rooted in discipline, innovation, and continuous improvement.
            </p>
          </motion.div>
        </div>

        <div className="relative max-w-5xl mx-auto">
          {/* Vertical Center Line - Gradient Path */}
          <div className="absolute left-8 md:left-1/2 transform md:-translate-x-1/2 h-full w-[3px] bg-gradient-to-b from-brand-accent via-brand-primary/40 to-brand-accent/20 shadow-sm rounded-full"></div>

          <div className="space-y-12">
            {milestones.map((item, idx) => (
              <div key={idx} className={`relative flex items-center justify-between md:flex-row flex-col ${idx % 2 === 0 ? '' : 'md:flex-row-reverse'}`}>
                
                {/* Year Badge & Node */}
                <div className="absolute left-8 md:left-1/2 transform -translate-x-1/2 flex items-center z-20">
                  <div className="flex flex-col items-center">
                    <div className="w-10 h-10 rounded-full bg-white border-2 border-brand-accent shadow-xl flex items-center justify-center group-hover:scale-110 transition-transform duration-500">
                       <div className="w-3 h-3 rounded-full bg-brand-accent animate-pulse shadow-[0_0_15px_rgba(226,135,67,0.5)]"></div>
                    </div>
                    <span className="mt-3 text-[11px] font-black text-brand-primary uppercase tracking-[0.25em] bg-brand-light/90 px-2 py-0.5 rounded-full backdrop-blur-sm border border-brand-primary/5">
                      {item.year}
                    </span>
                  </div>
                </div>

                {/* Milestone Card - Glass Style */}
                <motion.div 
                  initial={{ opacity: 0, x: idx % 2 === 0 ? -50 : 50 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.7, delay: idx * 0.1, ease: "easeOut" }}
                  className="w-full md:w-[45%] ml-16 md:ml-0"
                >
                  <div className="relative p-6 sm:p-8 glass-card glass-card-hover text-center rounded-[2rem]">
                    {/* Tiny connector line */}
                    <div className={`absolute top-1/2 -translate-y-1/2 w-8 h-[2px] bg-brand-primary/10 hidden md:block ${idx % 2 === 0 ? '-right-8' : '-left-8'}`}></div>
                    
                    <p className="text-brand-primary text-base md:text-lg font-medium leading-relaxed tracking-tight">
                      {item.content}
                    </p>
                  </div>
                </motion.div>

                {/* Empty Space for alignment */}
                <div className="w-full md:w-[45%] hidden md:block"></div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default TimelineSection;
