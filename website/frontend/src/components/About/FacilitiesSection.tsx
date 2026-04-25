import { motion } from 'framer-motion';
import { Microscope, Monitor, Book, Trophy, ShieldCheck } from 'lucide-react';

const FacilitiesSection = () => {
  const facilities = [
    { title: 'Modern Classrooms', icon: Monitor, color: 'bg-blue-50 text-blue-600' },
    { title: 'Interactive Science Labs', icon: Microscope, color: 'bg-orange-50 text-orange-600' },
    { title: 'Digital Resource Libary', icon: Book, color: 'bg-brand-primary/5 text-brand-primary' },
    { title: 'Sports & Athletics', icon: Trophy, color: 'bg-green-50 text-green-600' },
    { title: 'Secure Campus (CCTV)', icon: ShieldCheck, color: 'bg-red-50 text-red-600' },
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-white relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-20">
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary mb-6 text-center">World-Class Facilities</h2>
          <p className="text-gray-500 font-light leading-relaxed">
            A conducive environment is the foundation of effective learning. Our campuses are designed to provide students with the best infrastructure and safety.
          </p>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6 lg:gap-8">
          {facilities.map((facility, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, scale: 0.9 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: idx * 0.1 }}
              className="flex flex-col items-center justify-center p-6 sm:p-8 rounded-[1.5rem] sm:rounded-[2.5rem] bg-gray-50 border border-gray-100 hover:bg-white hover:shadow-xl hover:shadow-gray-200/50 transition-all text-center group"
            >
              <div className={`w-16 h-16 rounded-3xl ${facility.color} flex items-center justify-center mb-6 shadow-sm group-hover:scale-110 transition-transform`}>
                <facility.icon className="w-8 h-8" />
              </div>
              <h3 className="text-sm font-serif font-bold text-brand-primary tracking-wide leading-tight">
                {facility.title}
              </h3>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default FacilitiesSection;
