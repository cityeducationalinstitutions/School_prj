import { motion } from 'framer-motion';
import { Mail, ArrowRight } from 'lucide-react';

const ManagementProfiles = () => {
  const leaders = [
    {
      role: 'FOUNDER & CHAIRMAN',
      name: 'R Prakash Reddy',
      bio: 'Providing visionary leadership and a steadfast commitment to excellence in education. Under the guidance of R Prakash Reddy, City Educational Institutions has grown to become a beacon of holistic development and academic rigor.',
      image: '/8A6A0208.JPG.jpeg',
      quote: "Our mission is to nurture not just students, but future leaders who carry the torch of excellence and integrity."
    },
    {
      role: 'PRINCIPAL (CITY TALENT)',
      name: 'MR. MURALIDHAR',
      bio: 'Guiding academic excellence and fostering a culture of holistic student development at City Talent. His leadership ensures that the curriculum evolves with global trends while staying rooted in core human values.',
      image: '/indian_mother_professional_portrait_1776173533383.png'
    },
    {
      role: 'PRINCIPAL (CITY ELITE)',
      name: 'MR. KIRAN',
      bio: 'Nurturing student-centered education and operational excellence at City Elite. Mr. Kiran focuses on creating an environment where creative potential and academic rigor coexist in perfect balance.',
      image: '/media__1776171533667.jpg'
    },
    {
      role: 'PRINCIPAL (NEW VISION)',
      name: 'MS. SHUKRUTHA',
      bio: 'Committed to academic leadership and the holistic growth of students at New Vision. Ms. Shukrutha focuses on building a strong pedagogical foundation and fostering an environment of continuous learning.',
      image: '/indian_father_professional_portrait_1776173549630.png'
    }
  ];

  return (
    <section className="pb-16 pt-8 bg-white relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-12">
        
        {/* Page Title & Philosophy */}
        <div className="max-w-3xl mb-6 pt-4">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-serif font-bold text-brand-primary tracking-tighter leading-none mb-3">
              The Visionaries <span className="text-brand-accent italic font-light">Behind the Legacy</span>
            </h2>
            <div className="w-16 h-1 bg-brand-accent mb-3"></div>
            <p className="text-gray-500 text-sm md:text-base font-light leading-relaxed">
              Guided by decades of experience and a shared commitment to academic excellence, our leadership team ensures that every City campus remains a center of innovation and character building.
            </p>
          </motion.div>
        </div>

        {/* Founder Spotlight - Horizontal Executive Layout */}
        <div className="mb-24">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-100px" }}
            transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
            className="grid lg:grid-cols-12 items-center gap-8"
          >
            {/* Founder Photo - Left */}
            <motion.div 
              initial={{ opacity: 0, scale: 0.95 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ duration: 1, ease: [0.16, 1, 0.3, 1] }}
              className="lg:col-span-3 relative group"
            >
              <div className="aspect-[4/5] rounded-[1.5rem] overflow-hidden relative max-w-[220px] mx-auto lg:mx-0 border border-brand-accent/5">
                <img 
                  src={leaders[0].image} 
                  alt={leaders[0].name} 
                  className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-105"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-brand-primary/40 to-transparent"></div>
              </div>
            </motion.div>

            <motion.div 
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8, delay: 0.2, ease: [0.16, 1, 0.3, 1] }}
              className="lg:col-span-9 space-y-6"
            >
              <div className="space-y-3">
                <h4 className="text-brand-accent font-bold tracking-[0.2em] text-[10px] uppercase">{leaders[0].role}</h4>
                <h3 className="text-3xl md:text-4xl font-serif font-bold text-brand-primary tracking-tight">
                  {leaders[0].name}
                </h3>
              </div>
              
              <div className="relative">
                <p className="text-lg md:text-xl font-serif text-brand-primary leading-relaxed italic opacity-90 pl-8 border-l-4 border-brand-accent/30">
                  "{leaders[0].quote}"
                </p>
              </div>

              <p className="text-gray-600 text-base leading-relaxed font-light">
                {leaders[0].bio}
              </p>
            </motion.div>
          </motion.div>
        </div>

        {/* Principals Section - Alternating Layout */}
        <div className="space-y-16">
          {leaders.slice(1).map((leader, idx) => {
            const isImageRight = idx % 2 === 0; // idx 0 is first principal, should be right
            return (
              <motion.div
                key={idx}
                initial={{ opacity: 0, y: 40 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, margin: "-100px" }}
                transition={{ duration: 0.8, delay: idx * 0.1, ease: [0.16, 1, 0.3, 1] }}
                className="group grid lg:grid-cols-12 items-center gap-8"
              >
                <div className={`lg:col-span-10 space-y-4 ${isImageRight ? 'order-2 lg:order-1' : 'order-2'}`}>
                  <div className="space-y-2">
                    <span className="text-[10px] font-black tracking-[0.2em] text-brand-accent uppercase">
                      {leader.role}
                    </span>
                    <h4 className="text-xl lg:text-2xl font-serif font-bold text-brand-primary group-hover:text-brand-accent transition-colors">
                      {leader.name}
                    </h4>
                  </div>
                  <p className="text-gray-600 text-sm md:text-base font-light leading-relaxed">
                    {leader.bio}
                  </p>
                  <div className="pt-2">
                    <button className="text-brand-primary font-bold text-[10px] tracking-widest uppercase flex items-center gap-2 group-hover:gap-4 transition-all border-b border-transparent hover:border-brand-accent">
                      Full Profile <ArrowRight className="w-3 h-3 text-brand-accent" />
                    </button>
                  </div>
                </div>

                <motion.div 
                  initial={{ opacity: 0, scale: 0.9 }}
                  whileInView={{ opacity: 1, scale: 1 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.6, delay: (idx * 0.1) + 0.3 }}
                  className={`lg:col-span-2 relative ${isImageRight ? 'order-1 lg:order-2' : 'order-1'}`}
                >
                  <div className="aspect-[3/4] rounded-[1.25rem] overflow-hidden relative max-w-[180px] mx-auto lg:mx-0 border border-brand-accent/10">
                    <img 
                      src={leader.image} 
                      alt={leader.name} 
                      className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                      onError={(e) => {
                        (e.target as HTMLImageElement).src = `https://ui-avatars.com/api/?name=${encodeURIComponent(leader.name)}&background=fdf8f6&color=ff7849&size=600&bold=true`;
                      }}
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-brand-primary/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex flex-col justify-end p-6">
                      <div className="flex gap-4">
                        <div className="w-8 h-8 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center text-white hover:bg-brand-accent transition-colors cursor-pointer">
                          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="w-4 h-4">
                            <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/>
                            <rect width="4" height="12" x="2" y="9"/>
                            <circle cx="4" cy="4" r="2"/>
                          </svg>
                        </div>
                        <div className="w-8 h-8 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center text-white hover:bg-brand-accent transition-colors cursor-pointer">
                          <Mail className="w-4 h-4" />
                        </div>
                      </div>
                    </div>
                  </div>
                </motion.div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default ManagementProfiles;
