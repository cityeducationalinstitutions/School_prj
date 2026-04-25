import { motion } from 'framer-motion';
import { Search, MapPin, ClipboardList, UserCheck, CheckCircle } from 'lucide-react';

const ProcessTimeline = () => {
  const steps = [
    {
      icon: <Search className="w-8 h-8" />,
      title: "1. Enquiry",
      desc: "Fill the online form or visit us to start the journey."
    },
    {
      icon: <MapPin className="w-8 h-8" />,
      title: "2. Campus Tour",
      desc: "Experience our state-of-the-art facilities and ethos."
    },
    {
      icon: <ClipboardList className="w-8 h-8" />,
      title: "3. Application",
      desc: "Submit the registration form with required documents."
    },
    {
      icon: <UserCheck className="w-8 h-8" />,
      title: "4. Interaction",
      desc: "Engage in a friendly session with our academic team."
    },
    {
      icon: <CheckCircle className="w-8 h-8" />,
      title: "5. Admission",
      desc: "Receive confirmation and complete the enrolment."
    }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-brand-primary relative overflow-hidden">
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-[0.03] pointer-events-none">
        <div className="absolute inset-0" style={{ backgroundImage: 'radial-gradient(circle at 2px 2px, white 1px, transparent 0)', backgroundSize: '40px 40px' }}></div>
      </div>

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        <div className="text-center mb-20 space-y-4">
          <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block">Path to Excellence</span>
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-white tracking-tighter leading-none">
            The Admission <span className="text-brand-accent italic font-light">Journey.</span>
          </h2>
          <div className="w-20 h-1 bg-brand-accent/20 rounded-full mx-auto mt-6"></div>
        </div>

        <div className="relative">
          {/* Connecting Line (Desktop) */}
          <div className="absolute top-1/2 left-0 w-full h-[1px] bg-gradient-to-r from-transparent via-white/20 to-transparent hidden lg:block -translate-y-1/2"></div>

          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-12 lg:gap-8">
            {steps.map((step, idx) => (
              <motion.div 
                key={idx}
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: idx * 0.1, duration: 0.6 }}
                className="relative group flex flex-col items-center text-center"
              >
                {/* Icon Container */}
                <div className="w-24 h-24 rounded-[2rem] bg-white/5 border border-white/10 backdrop-blur-sm flex items-center justify-center text-brand-accent mb-8 group-hover:bg-brand-accent group-hover:text-white group-hover:scale-110 transition-all duration-500 shadow-xl group-hover:shadow-brand-accent/20 relative z-20">
                  <div className="transform group-hover:rotate-12 transition-transform duration-500">
                    {step.icon}
                  </div>
                </div>

                {/* Content */}
                <div className="space-y-3 relative z-20">
                  <h3 className="text-xl font-bold text-white tracking-tight">{step.title}</h3>
                  <p className="text-sm text-white/60 font-light leading-relaxed px-4">{step.desc}</p>
                </div>

                {/* Connectors (Desktop dots) */}
                {idx < steps.length - 1 && (
                  <div className="absolute top-12 left-full w-full h-px border-t border-dashed border-white/20 hidden lg:block -z-10"></div>
                )}
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default ProcessTimeline;
