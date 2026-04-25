import { motion } from 'framer-motion';

const ManagementProfiles = () => {
  const leaders = [
    {
      role: 'FOUNDER',
      name: 'R Prakash Reddy',
      bio: 'Providing visionary leadership and a steadfast commitment to excellence in education. Under the guidance of R Prakash Reddy, City Educational Institutions has grown to become a beacon of holistic development and academic rigor.',
      image: '/founder_portrait_professional_1776343305701.png',
    },
    {
      role: 'PRINCIPAL (CITY TALENT HIGH SCHOOL)',
      name: 'MR. MURALIDHAR',
      bio: 'Guiding academic excellence and fostering a culture of holistic student development at City Talent. His leadership ensures that the curriculum evolves with global trends while staying rooted in core human values.',
      image: '/indian_mother_professional_portrait_1776173533383.png'
    },
    {
      role: 'PRINCIPAL (CITY ELITE SCHOOL)',
      name: 'MR. KIRAN',
      bio: 'Nurturing student-centered education and operational excellence at City Elite. Mr. Kiran focuses on creating an environment where creative potential and academic rigor coexist in perfect balance, empowering students to achieve their best.',
      image: '/media__1776171533667.jpg'
    },
    {
      role: 'PRINCIPAL (NEW VISION SCHOOL)',
      name: 'MS. SHUKRUTHA',
      bio: 'Committed to academic leadership and the holistic growth of students at New Vision. Ms. Shukrutha focuses on building a strong pedagogical foundation and fostering an environment of continuous learning.',
      image: '/indian_father_professional_portrait_1776173549630.png'
    }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-brand-light relative overflow-hidden">
      {/* Background Soft Glows */}
      <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-brand-accent/5 rounded-full blur-[120px] translate-x-1/2 -z-10"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Intro Header */}
        <div className="text-center mb-24">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <span className="text-brand-accent font-bold tracking-[0.3em] uppercase text-xs mb-4 block">Institutional Leadership</span>
            <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold mb-8 tracking-tighter leading-tight text-center">
              <span className="text-brand-primary">The Pillars of </span>
              <span className="text-brand-accent italic font-light">Our Institution</span>
            </h2>
            <div className="w-24 h-1.5 bg-brand-accent mx-auto rounded-full"></div>
          </motion.div>
        </div>

        {/* Leadership List - Matching Screenshot Style */}
        <div className="space-y-16 lg:space-y-24">
          {leaders.map((leader, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8, delay: idx * 0.1 }}
              className="flex flex-col lg:flex-row items-stretch gap-10 lg:gap-16"
            >
              {/* Image Side - Rounded Rectangle */}
              <div className="w-full lg:w-[350px] flex-shrink-0">
                <div className="aspect-[4/5] h-full rounded-[2.5rem] overflow-hidden shadow-xl border-4 border-white transition-transform duration-700 hover:scale-[1.02]">
                  <img 
                    src={leader.image} 
                    alt={leader.name} 
                    className="w-full h-full object-cover"
                    onError={(e) => {
                      (e.target as HTMLImageElement).src = `https://ui-avatars.com/api/?name=${encodeURIComponent(leader.name)}&background=fdf8f6&color=ff7849&size=600&bold=true`;
                    }}
                  />
                </div>
              </div>

              {/* Content Side - White Rounded Card */}
              <div className="flex-grow bg-white p-6 sm:p-12 rounded-[2rem] sm:rounded-[2.5rem] shadow-[0_20px_50px_rgba(0,0,0,0.04)] border border-gray-50 flex flex-col justify-center">
                <div className="mb-8">
                  <span className="inline-block px-8 py-2.5 rounded-full border-2 border-brand-accent/20 bg-brand-accent/[0.02] text-brand-accent font-bold text-xs tracking-[0.2em] uppercase mb-6">
                    {leader.role}
                  </span>
                  <h3 className="text-2xl sm:text-4xl lg:text-5xl font-serif font-bold text-brand-accent leading-tight">
                    {leader.name}
                  </h3>
                </div>

                <div className="space-y-6">
                  <p className="text-gray-600 text-base sm:text-lg lg:text-xl font-light leading-relaxed">
                    {leader.bio}
                  </p>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default ManagementProfiles;
