import { motion } from 'framer-motion';
import { Check } from 'lucide-react';

export default function AcademicsSection({
  description1 = "We follow a rigorous CBSE Curriculum designed to challenge students and foster intellectual growth. Our approach integrates standard academics with skill-building exercises.",
  description2 = "By maintaining a balance between theoretical knowledge and practical evaluation, we ensure our students are well-prepared for higher education challenges.",
  image = "https://images.unsplash.com/photo-1577896851231-70ef18881754?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80"
}: {
  description1?: string;
  description2?: string;
  image?: string;
}) {
  const subjects = [
    "English Language & Literature",
    "Mathematics",
    "Science (Physics, Chemistry, Biology)",
    "Social Science",
    "Computer Science / IT",
    "Second Languages (Hindi/Regional)"
  ];

  return (
    <section className="relative py-[clamp(4rem,10vh,8rem)] bg-transparent overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute top-1/2 left-0 w-[500px] h-[500px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 -translate-x-1/2 -translate-y-1/2 opacity-60 hidden sm:block"></div>
      <div className="absolute top-1/4 right-0 w-[400px] h-[400px] bg-brand-primary/5 rounded-full blur-[100px] -z-10 translate-x-1/2 opacity-40 hidden sm:block"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-20 items-center">
          
          <motion.div 
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 1.2, ease: [0.23, 1, 0.32, 1] }}
            className="relative"
          >
            {/* Soft Glow Background */}
            <div className="absolute -inset-10 bg-brand-accent/5 blur-[100px] -z-10 rounded-full"></div>
            
            <div className="relative aspect-[4/5] overflow-hidden rounded-[3rem] shadow-[0_50px_100px_-20px_rgba(0,0,0,0.15)] transition-all duration-700">
              <img 
                src={image} 
                alt="Campus Academics" 
                className="w-full h-full object-cover"
              />
              {/* Premium Overlay Gradient */}
              <div className="absolute inset-0 bg-gradient-to-t from-brand-primary/40 via-transparent to-brand-primary/10 mix-blend-multiply opacity-60"></div>
              <div className="absolute inset-0 border-[16px] border-white/10 rounded-[3rem]"></div>
            </div>
          </motion.div>

          <motion.div 
            initial={{ opacity: 0, x: 50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 1.2, ease: [0.23, 1, 0.32, 1] }}
            className="flex flex-col space-y-12"
          >
            <div className="space-y-8">
              <div className="space-y-4">
                <span className="text-[10px] md:text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block mb-2">Curriculum Excellence</span>
                <h2 className="text-[clamp(2rem,6vh,4rem)] font-serif text-brand-primary tracking-tighter leading-tight">
                  Academic <span className="text-brand-accent italic font-light drop-shadow-sm">Excellence.</span>
                </h2>
                <div className="w-24 h-1.5 bg-gradient-to-r from-brand-accent to-transparent rounded-full mt-4"></div>
              </div>
              
              <div className="space-y-6">
                <div className="text-gray-600 font-light text-xl md:text-2xl leading-relaxed border-l-4 border-brand-accent/20 pl-8" dangerouslySetInnerHTML={{ __html: description1 }} />
                <p className="text-gray-500 font-light text-lg leading-relaxed pl-8">
                  {description2}
                </p>
              </div>
            </div>

            <div className="bg-white/40 backdrop-blur-3xl rounded-[3rem] p-10 sm:p-12 border border-white/60 shadow-[0_30px_60px_-15px_rgba(0,0,0,0.05)] relative overflow-hidden group">
              {/* Background Decorative element */}
              <div className="absolute -top-20 -right-20 w-64 h-64 bg-brand-accent/5 rounded-full blur-[80px] -z-10 transition-transform duration-1000 group-hover:scale-150"></div>
              
              <h3 className="text-xs font-black text-brand-primary/40 mb-10 uppercase tracking-[0.4em] flex items-center">
                <span className="w-12 h-[2px] bg-brand-accent/30 mr-6"></span>
                Key Subjects Offered
              </h3>
              
              <ul className="grid grid-cols-1 sm:grid-cols-2 gap-x-12 gap-y-8">
                {subjects.map((subject, idx) => (
                  <li key={idx} className="flex items-center text-gray-700 transition-all duration-500 group/item">
                    <div className="w-8 h-8 rounded-xl bg-brand-accent/5 border border-brand-accent/10 flex items-center justify-center mr-5 shrink-0 transition-all duration-500 group-hover/item:bg-brand-accent group-hover/item:border-brand-accent group-hover/item:shadow-lg group-hover/item:shadow-brand-accent/20">
                      <Check className="w-4 h-4 text-brand-accent transition-colors duration-500 group-hover/item:text-white" strokeWidth={3} />
                    </div>
                    <span className="text-base font-semibold text-brand-primary/80 group-hover/item:text-brand-primary group-hover/item:translate-x-1 transition-all duration-500">{subject}</span>
                  </li>
                ))}
              </ul>
            </div>

          </motion.div>

        </div>
      </div>
    </section>
  );
}
