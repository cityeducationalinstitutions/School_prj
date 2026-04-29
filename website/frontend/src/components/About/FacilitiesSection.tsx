import { motion } from 'framer-motion';
import { Microscope, Monitor, Book, Trophy, ShieldCheck } from 'lucide-react';

const facilities = [
  { 
    title: 'Modern Classrooms', 
    description: 'Smart classrooms equipped with digital boards and interactive learning tools to enhance engagement and clarity.',
    icon: Monitor, 
    image: '/facility_classroom.png',
    color: 'text-blue-600',
    borderColor: 'border-blue-500',
    bgColor: 'bg-blue-50'
  },
  { 
    title: 'Interactive Science Labs', 
    description: 'Hands-on laboratory experiences that encourage experimentation, discovery, and scientific thinking.',
    icon: Microscope, 
    image: '/facility_lab.png',
    color: 'text-orange-600',
    borderColor: 'border-orange-500',
    bgColor: 'bg-orange-50'
  },
  { 
    title: 'Digital Resource Library', 
    description: 'A well-curated collection of digital and physical resources to support independent and guided learning.',
    icon: Book, 
    image: '/facility_library.png',
    color: 'text-purple-600',
    borderColor: 'border-purple-500',
    bgColor: 'bg-purple-50'
  },
  { 
    title: 'Sports & Athletics', 
    description: 'Dedicated sports facilities that promote physical fitness, teamwork, and competitive spirit.',
    icon: Trophy, 
    image: '/facility_sports.png',
    color: 'text-green-600',
    borderColor: 'border-green-500',
    bgColor: 'bg-green-50'
  },
  { 
    title: 'Secure Campus (CCTV)', 
    description: 'A safe and monitored environment with 24/7 surveillance ensuring student safety and peace of mind.',
    icon: ShieldCheck, 
    image: '/facility_security.png',
    color: 'text-red-600',
    borderColor: 'border-red-500',
    bgColor: 'bg-red-50'
  },
];

const features = [
  { icon: '/icons/safe_shield_3d.png', label: 'Safe Environment', sublabel: 'Your safety is our priority' },
  { icon: '/icons/faculty_3d.png', label: 'Expert Faculty', sublabel: 'Guiding every step' },
  { icon: '/icons/infra_building_3d.png', label: 'Modern Infrastructure', sublabel: 'Built for the future' },
  { icon: '/icons/holistic_3d.png', label: 'Holistic Development', sublabel: 'Nurturing every potential' },
];

const FacilitiesSection = () => {
  return (
    <section className="pt-24 pb-12 bg-[#FAFBFF] relative overflow-hidden">
      {/* Background abstract elements */}
      <div className="absolute top-0 right-0 w-64 h-64 bg-brand-primary/5 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl opacity-50" />
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-brand-accent/5 rounded-full translate-y-1/2 -translate-x-1/2 blur-3xl opacity-30" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header */}
        <div className="text-center max-w-3xl mx-auto mb-20">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="flex items-center justify-center gap-2 mb-4"
          >
            <div className="h-[2px] w-8 bg-brand-accent" />
            <span className="text-brand-accent font-serif italic text-lg">Excellence in Every Detail</span>
            <div className="h-[2px] w-8 bg-brand-accent" />
          </motion.div>
          
          <motion.h2 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.1 }}
            className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold mb-8"
          >
            <span className="text-[#0F172A]">World-Class</span>{' '}
            <span className="text-[#F97316]">Facilities</span>
          </motion.h2>

          <motion.p 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.2 }}
            className="text-gray-500 text-lg leading-relaxed max-w-2xl mx-auto"
          >
            A conducive environment is the foundation of effective learning. Our campuses are designed to provide students with the best infrastructure and safety.
          </motion.p>
        </div>

        {/* Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 lg:gap-8 mb-4">
          {facilities.map((facility, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: idx * 0.1 }}
              className="relative flex flex-col h-full rounded-[2rem] bg-white/70 backdrop-blur-md border border-white/40 shadow-xl overflow-hidden group transition-all duration-500 hover:scale-[1.02] hover:shadow-2xl z-10"
            >
              {/* Image Container */}
              <div className="relative h-48 w-full overflow-hidden">
                <img 
                  src={facility.image} 
                  alt={facility.title}
                  className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-white via-transparent to-transparent opacity-60" />
              </div>

              {/* Floating Icon */}
              <div className={`absolute top-40 left-1/2 -translate-x-1/2 w-14 h-14 rounded-2xl ${facility.bgColor} ${facility.color} flex items-center justify-center shadow-lg border border-white/50 z-30 transition-transform duration-500 group-hover:scale-110`}>
                <facility.icon className="w-7 h-7" />
              </div>

              {/* Content */}
              <div className="flex-grow pt-10 px-6 pb-8 text-center flex flex-col">
                <h3 className="text-xl font-serif font-bold text-[#F97316] mb-4 transition-colors">
                  {facility.title}
                </h3>
                <p className="text-gray-500 text-sm leading-relaxed mb-2 flex-grow">
                  {facility.description}
                </p>
              </div>

              {/* Bottom Border Accent */}
              <div className={`absolute bottom-0 left-0 right-0 h-1.5 ${facility.borderColor.replace('border-', 'bg-')}`} />
            </motion.div>
          ))}
        </div>

        {/* Feature Bar */}
        <motion.div 
          initial={{ opacity: 0, y: 40 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="mt-4 bg-white rounded-[2.5rem] shadow-xl shadow-gray-200/50 p-6 md:p-10 border border-gray-100"
        >
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, idx) => (
              <div key={idx} className="flex items-center gap-4 group">
                <div className="w-20 h-20 rounded-2xl bg-brand-primary/5 flex items-center justify-center transition-all duration-300 group-hover:bg-brand-primary/10 group-hover:scale-110 group-hover:shadow-lg group-hover:shadow-brand-primary/5">
                  <img src={feature.icon} alt={feature.label} className="w-16 h-16 object-contain drop-shadow-md" />
                </div>
                <div>
                  <h4 className="font-serif font-bold text-[#F97316] mb-1">{feature.label}</h4>
                  <p className="text-xs text-gray-500">{feature.sublabel}</p>
                </div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default FacilitiesSection;
