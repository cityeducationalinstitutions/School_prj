import { motion } from 'framer-motion';
import { ArrowRight } from 'lucide-react';

const AdmissionJourney = () => {
  const steps = [
    {
      id: 1,
      icon: <img src="/icons/3d-enquiry.png" alt="Enquiry" className="w-20 h-20 object-contain" />,
      title: "1. Enquiry",
      desc: "Fill the online form or visit us to start the journey.",
      active: false
    },
    {
      id: 2,
      icon: <img src="/icons/3d-campus-tour.png" alt="Campus Tour" className="w-20 h-20 object-contain" />,
      title: "2. Campus Tour",
      desc: "Experience our state-of-the-art facilities and ethos.",
      active: false
    },
    {
      id: 3,
      icon: <img src="/icons/3d-application.png" alt="Application" className="w-20 h-20 object-contain" />,
      title: "3. Application",
      desc: "Submit the registration form with required documents.",
      active: true
    },
    {
      id: 4,
      icon: <img src="/icons/3d-interaction.png" alt="Interaction" className="w-20 h-20 object-contain" />,
      title: "4. Interaction",
      desc: "Engage in a friendly session with our academic team.",
      active: false
    },
    {
      id: 5,
      icon: <img src="/icons/3d-admission.png" alt="Admission" className="w-20 h-20 object-contain" />,
      title: "5. Admission",
      desc: "Receive confirmation and complete the enrolment.",
      active: false
    }
  ];

  const features = [
    { icon: <img src="/icons/3d-trusted.png" alt="Trusted" className="w-10 h-10 object-contain" />, title: "Trusted Process", desc: "Transparent & reliable" },
    { icon: <img src="/icons/3d-guidance.png" alt="Guidance" className="w-10 h-10 object-contain" />, title: "Expert Guidance", desc: "Personalised support" },
    { icon: <img src="/icons/3d-time.png" alt="Time" className="w-10 h-10 object-contain" />, title: "Save Time", desc: "Quick & hassle-free" },
    { icon: <img src="/icons/3d-future.png" alt="Future" className="w-10 h-10 object-contain" />, title: "Bright Future", desc: "Begin your journey" }
  ];

  return (
    <section className="pt-12 pb-20 bg-[#FFFBF7] relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Top Header Section */}
        <div className="text-center mb-16">
          <div className="flex items-center justify-center gap-4 mb-4">
            <div className="h-[1px] w-12 bg-brand-accent/20"></div>
            <span className="text-[10px] font-black tracking-[0.4em] text-brand-accent uppercase">Path to Excellence</span>
            <div className="h-[1px] w-12 bg-brand-accent/20"></div>
          </div>
          
          <h2 className="text-[clamp(2.5rem,6vh,4rem)] font-serif text-[#1A1A1A] leading-none tracking-tight mb-4">
            The Admission <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF8C42] to-[#FF6A00] italic font-light">Journey.</span>
          </h2>
          
          <p className="text-gray-500 font-medium text-lg">
            Simple steps towards a brighter future
          </p>
          <div className="w-24 h-1 bg-gradient-to-r from-transparent via-[#FF8C42]/30 to-transparent mx-auto mt-6 rounded-full"></div>
        </div>



        {/* Step Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6 lg:gap-4 mb-8">
          {steps.map((step) => (
            <motion.div
              key={step.id}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: step.id * 0.1 }}
              className={`relative bg-white p-8 rounded-[2.5rem] border transition-all duration-500 flex flex-col items-center text-center
                ${step.active 
                  ? 'border-brand-accent/20 shadow-[0_30px_60px_-15px_rgba(255,140,66,0.15)] scale-105 z-20' 
                  : 'border-gray-100 shadow-sm hover:shadow-md'}`}
            >
              {/* Icon Container */}
              <div className={`w-24 h-24 flex items-center justify-center mb-6 transition-all duration-500 hover:scale-110
                ${step.active ? 'drop-shadow-[0_20px_30px_rgba(255,140,66,0.2)]' : 'opacity-80 hover:opacity-100'}`}
              >
                {step.icon}
              </div>

              <div className="space-y-4 mb-8 flex-grow">
                <h3 className={`text-xl font-bold tracking-tight ${step.active ? 'text-[#1A1A1A]' : 'text-[#333333]'}`}>
                  {step.title}
                </h3>
                <p className="text-sm text-gray-500 font-medium leading-relaxed">
                  {step.desc}
                </p>
              </div>

              {step.active ? (
                <button 
                  onClick={() => {
                    const element = document.getElementById('admission-form');
                    element?.scrollIntoView({ behavior: 'smooth' });
                  }}
                  className="px-8 py-3 bg-gradient-to-r from-[#FF8C42] to-[#FF6A00] text-white text-xs font-black tracking-widest uppercase rounded-xl shadow-lg shadow-orange-500/30 flex items-center gap-2 group transition-transform hover:scale-105 active:scale-95"
                >
                  Apply Now
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </button>
              ) : (
                <button className="w-10 h-10 rounded-full border border-gray-100 flex items-center justify-center text-gray-400 hover:bg-brand-accent hover:text-white hover:border-brand-accent transition-all">
                  <ArrowRight className="w-4 h-4" />
                </button>
              )}
            </motion.div>
          ))}
        </div>

        {/* Bottom Feature Bar */}
        <div className="bg-white rounded-[2rem] p-3 shadow-[0_20px_50px_rgba(0,0,0,0.04)] border border-gray-100">
          <div className="grid grid-cols-2 lg:grid-cols-4 divide-y lg:divide-y-0 lg:divide-x divide-gray-100">
            {features.map((feature, idx) => (
              <div key={idx} className="flex items-center gap-5 px-6 py-4">
                <div className="w-12 h-12 flex items-center justify-center">
                  {feature.icon}
                </div>
                <div>
                  <h4 className="text-sm font-bold text-[#1A1A1A] tracking-tight">{feature.title}</h4>
                  <p className="text-[10px] text-gray-400 font-bold uppercase tracking-wider">{feature.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

      </div>
    </section>
  );
};

export default AdmissionJourney;
