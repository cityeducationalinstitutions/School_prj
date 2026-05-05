import { motion } from 'framer-motion';

const TimelineSection = () => {
  const milestones = [
    {
      year: "2003",
      title: "A Vision Takes Root",
      content: "Established with a clear mission to deliver value-based education, laying a strong academic and ethical foundation for future generations.",
      icon: <img src="/icons/3d-timeline-school.png" alt="School" className="w-10 h-10 object-contain" />
    },
    {
      year: "2010",
      title: "Expanding Horizons",
      content: "Introduced diverse co-curricular programs and structured physical education tracks, shaping well-rounded individuals beyond academics.",
      icon: <img src="/icons/3d-timeline-book.png" alt="Book" className="w-10 h-10 object-contain" />
    },
    {
      year: "2015",
      title: "Strengthening Infrastructure",
      content: "Transformed into a modern, fully-equipped institution with advanced classrooms and enhanced learning environments.",
      icon: <img src="/icons/3d-timeline-building.png" alt="Building" className="w-10 h-10 object-contain" />
    },
    {
      year: "2021",
      title: "Embracing Digital Innovation",
      content: "Integrated smart digital tools and technology-driven learning methods to elevate student engagement and academic performance.",
      icon: <img src="/icons/3d-timeline-digital.png" alt="Digital" className="w-10 h-10 object-contain" />
    },
    {
      year: "2025",
      title: "Legacy of Excellence",
      content: "Celebrating over two decades of consistent academic success, outstanding SSC results, and a reputation built on trust and excellence.",
      icon: <img src="/icons/3d-timeline-trophy.png" alt="Trophy" className="w-10 h-10 object-contain" />
    }
  ];

  const features = [
    {
      title: "Strong Academic Foundation",
      text: "Building concepts, character and confidence.",
      icon: <img src="/icons/3d-feature-foundation.png" alt="Foundation" className="w-10 h-10 object-contain" />
    },
    {
      title: "Holistic Student Development",
      text: "Nurturing minds, bodies and values.",
      icon: <img src="/icons/3d-feature-holistic.png" alt="Holistic" className="w-10 h-10 object-contain" />
    },
    {
      title: "Future-Ready Learning Approach",
      text: "Innovative education for a changing world.",
      icon: <img src="/icons/3d-feature-future.png" alt="Future" className="w-10 h-10 object-contain" />
    },
    {
      title: "Proven Track Record of Excellence",
      text: "Results that reflect our commitment.",
      icon: <img src="/icons/3d-feature-proven.png" alt="Proven" className="w-10 h-10 object-contain" />
    }
  ];

  return (
    <section className="py-6 bg-white relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Top Header Section */}
        <div className="text-center mb-6">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <span className="inline-block py-1 px-4 rounded-full bg-brand-accent/10 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-2">
              OUR LEGACY. OUR COMMITMENT. OUR FUTURE.
            </span>
            <h2 className="text-[clamp(1.5rem,4vw,2.5rem)] font-serif font-bold mb-3 tracking-tighter leading-none">
              <span className="text-brand-primary">Journey of </span>
              <span className="text-brand-accent">Academic Excellence</span>
            </h2>
          </motion.div>
        </div>

        {/* Timeline Section */}
        <div className="relative max-w-5xl mx-auto mb-4">
          {/* Vertical Center Line */}
          <div className="absolute left-8 md:left-1/2 transform md:-translate-x-1/2 h-full w-[2px] bg-gradient-to-b from-brand-accent/20 via-brand-accent to-brand-accent/20 rounded-full"></div>

          <div className="space-y-0">
            {milestones.map((item, idx) => (
              <div key={idx} className={`relative flex items-center justify-between md:flex-row flex-col ${idx % 2 === 0 ? '' : 'md:flex-row-reverse'}`}>
                
                {/* Year Label in Center */}
                <div className="absolute left-8 md:left-1/2 transform -translate-x-1/2 flex items-center justify-center z-20">
                  <div className="w-3 h-3 rounded-full bg-white border-2 border-brand-accent shadow-sm"></div>
                  <div className="absolute top-6 px-2 py-0.5 rounded-full bg-brand-accent text-white text-[9px] font-bold tracking-wider">
                    {item.year}
                  </div>
                </div>

                {/* Card */}
                <motion.div 
                  initial={{ opacity: 0, x: idx % 2 === 0 ? -40 : 40 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.7, delay: idx * 0.1 }}
                  className="w-full md:w-[42%] ml-16 md:ml-0 py-2"
                >
                  <div className="bg-white p-5 rounded-[1.5rem] shadow-lg shadow-gray-100/50 border border-gray-50 group hover:-translate-y-1 transition-all duration-500 flex flex-col items-center text-center">
                    <div className="w-10 h-10 rounded-xl bg-brand-accent/5 flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                      {item.icon}
                    </div>
                    <h4 className="text-lg font-sans font-bold text-brand-accent mb-1.5 leading-tight tracking-tight">{item.title}</h4>
                    <p className="text-gray-500 text-[13px] leading-relaxed">
                      {item.content}
                    </p>
                  </div>
                </motion.div>

                {/* Spacer */}
                <div className="w-full md:w-[42%] hidden md:block"></div>
              </div>
            ))}
          </div>
        </div>

        {/* Bottom Feature Bar */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 pt-8 border-t border-gray-100">
          {features.map((feature, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: idx * 0.1 }}
              className="bg-white p-6 rounded-2xl border border-gray-100 hover:shadow-lg transition-all duration-300 text-center flex flex-col items-center"
            >
              <div className="mb-4 p-3 rounded-xl bg-brand-accent/5">
                {feature.icon}
              </div>
              <h5 className="text-sm font-sans font-bold text-brand-accent mb-2 uppercase tracking-wide">{feature.title}</h5>
              <p className="text-xs text-gray-500 leading-relaxed">{feature.text}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default TimelineSection;
