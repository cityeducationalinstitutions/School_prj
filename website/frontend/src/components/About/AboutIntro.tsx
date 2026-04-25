import { motion } from 'framer-motion';

const AboutIntro = () => {
  const stats = [
    { label: 'Founded', value: '2003', description: '' },
    { label: 'Excellence', value: '21+ Years', description: '' },
    { label: 'Campuses', value: '3', description: '' },
    { label: 'Students', value: '1600+', description: '' },
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-brand-light overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-20 items-center">
          
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
            className="relative"
          >
            <div className="absolute -left-4 top-0 w-1 h-24 bg-brand-accent rounded-full opacity-50"></div>
            <h2 className="text-[clamp(1.75rem,5.5vh,4rem)] font-serif text-brand-primary mb-8 leading-[1.05] tracking-tighter">
              Built on Strong Foundations, <br />
              Focused on <span className="text-brand-accent italic">Holistic Development</span>
            </h2>
            <div className="space-y-6 text-gray-500 text-lg leading-relaxed max-w-xl">
              <p>
                At City Educational Institutions, we believe that strong foundations are the key to lifelong success. For decades, we have been committed to delivering quality education that nurtures academic excellence, character, and confidence in every student.
              </p>
              <p>
                Our approach blends time-tested values with modern teaching methodologies, creating a student-centered environment that encourages critical thinking, innovation, and disciplined growth — preparing every learner to excel in the challenges of the future.
              </p>
            </div>
          </motion.div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 relative">
            {/* Background Decorative Element */}
            <div className="absolute inset-0 bg-brand-accent/5 rounded-[3rem] -rotate-2 -z-10"></div>
            
            {stats.map((stat, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.1 }}
                className="p-8 sm:p-10 rounded-[1.5rem] sm:rounded-[2.5rem] bg-white border border-gray-100 shadow-sm hover:shadow-xl hover:-translate-y-2 transition-all duration-300 group flex flex-col justify-center items-center text-center min-h-[180px]"
              >
                <div className="text-3xl sm:text-4xl font-serif font-bold text-brand-primary mb-2 group-hover:text-brand-accent transition-colors">
                  {stat.value}
                </div>
                <div className="text-xs font-bold text-brand-accent uppercase tracking-[0.2em]">
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </div>
          
        </div>
      </div>
    </section>
  );
};

export default AboutIntro;
