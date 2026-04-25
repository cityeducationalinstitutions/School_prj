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
            transition={{ duration: 1, ease: "easeOut" }}
            className="relative"
          >
            {/* Decorative Frame */}
            <div className="absolute -inset-4 border border-brand-accent/10 rounded-[2.5rem] -z-10 pointer-events-none"></div>
            
            <div className="aspect-[4/5] overflow-hidden rounded-[2rem] shadow-2xl transform transition-transform duration-700 hover:scale-[1.02]">
              <img 
                src={image} 
                alt="Campus Academics" 
                className="w-full h-full object-cover transition-all duration-1000 group-hover:scale-110"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-brand-primary/20 to-transparent"></div>
            </div>
          </motion.div>

          <motion.div 
            initial={{ opacity: 0, x: 50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 1, ease: "easeOut" }}
            className="flex flex-col space-y-10"
          >
            <div className="space-y-6">
              <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block">Academic Excellence</span>
              <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary tracking-tighter leading-[0.9]">
                Academic <br/>
                <span className="text-brand-accent italic font-light drop-shadow-sm">Excellence.</span>
              </h2>
              <div className="w-20 h-1 bg-brand-accent/20 rounded-full"></div>
              
              <div className="space-y-4">
                <div className="text-gray-600 font-light text-lg md:text-xl leading-relaxed" dangerouslySetInnerHTML={{ __html: description1 }} />
                <p className="text-gray-500 font-light leading-relaxed">
                  {description2}
                </p>
              </div>
            </div>

            <div className="glass-card rounded-[2rem] p-10 border border-white relative overflow-hidden group">
              <div className="absolute top-0 right-0 w-32 h-32 bg-brand-accent/5 rounded-full blur-3xl -z-10"></div>
              
              <h3 className="text-lg font-bold text-brand-primary mb-8 uppercase tracking-[0.2em] flex items-center">
                <span className="w-8 h-px bg-brand-accent mr-4"></span>
                Key Subjects Offered
              </h3>
              
              <ul className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                {subjects.map((subject, idx) => (
                  <li key={idx} className="flex items-start text-sm text-gray-600 group/item">
                    <div className="w-6 h-6 rounded-full bg-brand-accent/10 flex items-center justify-center mr-4 shrink-0 transition-colors duration-300 group-hover/item:bg-brand-accent">
                      <Check className="w-3 h-3 text-brand-accent transition-colors duration-300 group-hover/item:text-white" />
                    </div>
                    <span className="font-medium group-hover/item:text-brand-primary transition-colors duration-300">{subject}</span>
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
