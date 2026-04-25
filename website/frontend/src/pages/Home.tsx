import { useState } from 'react';
import Hero from '../components/Hero';
import { ArrowRight, Users, Lightbulb, Eye, Target, Star, School, Quote, TrendingUp } from 'lucide-react';
import { Link } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { useEffect } from 'react';
import AdmissionsPopup from '../components/Admissions/AdmissionsPopup';

export default function Home() {
  const [showPopup, setShowPopup] = useState(false);

  useEffect(() => {
    // Check if popup was already shown in this session
    const hasSeenPopup = sessionStorage.getItem('hasSeenAdmissionsPopup');
    
    if (!hasSeenPopup) {
      const timer = setTimeout(() => {
        setShowPopup(true);
        sessionStorage.setItem('hasSeenAdmissionsPopup', 'true');
      }, 3000);

      return () => clearTimeout(timer);
    }
  }, []);

  const testimonials = [
    {
      text: "City Educational Institutions has been a transformative platform for my daughter. The balance between academic rigor and creative extracurriculars has boosted her confidence immensely. We truly appreciate the futuristic approach to learning.",
      author: "Priyanka Reddy"
    },
    {
      text: "The infrastructure and the quality of teachers at the City Elite campus are outstanding. My children have developed a genuine love for learning and have shown remarkable progress in their analytical skills.",
      author: "Ananya Sharma"
    },
    {
      text: "What sets this school apart is the personalized care and the state-of-the-art facilities. The bridge between traditional values and modern technology in the classroom is perfect for our children.",
      author: "Vikram Malhotra"
    }
  ];


  return (
    <div className="bg-brand-light">
      <Hero />
      
      {/* About Preview Section */}
      <section className="relative py-[clamp(4rem,10vh,8rem)] px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto overflow-hidden">
        {/* Ambient Focal Point */}
        <div className="absolute top-1/2 left-0 -translate-y-1/2 w-[600px] h-[600px] bg-brand-accent/10 rounded-full blur-[120px] -z-10 opacity-60 animate-pulse hidden sm:block"></div>
        <div className="absolute top-0 right-0 w-[400px] h-[400px] bg-brand-primary/5 rounded-full blur-[100px] -z-10 hidden sm:block"></div>
        
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          {/* Left Side: Staggered Images */}
          <div className="relative h-[600px] w-full hidden md:block">
            <div className="absolute top-4 left-4 w-[48%] h-[65%] rounded-[2.5rem] overflow-hidden shadow-elite z-10 border-4 border-white/40 group/img">
              <img 
                src="/about/classroom_elite.png" 
                alt="Students learning in classroom" 
                className="w-full h-full object-cover transition-transform duration-1000 group-hover/img:scale-105" 
              />
              <div className="absolute inset-0 ring-1 ring-inset ring-white/20 rounded-[2.5rem]"></div>
            </div>
            <div className="absolute bottom-4 right-4 w-[48%] h-[65%] rounded-[2.5rem] overflow-hidden shadow-elite z-20 border-8 border-white group/img2">
              <img 
                src="/about/lecture_hall_elite.png" 
                alt="Modern school lecture hall" 
                className="w-full h-full object-cover transition-transform duration-1000 group-hover/img2:scale-105" 
              />
              <div className="absolute inset-0 ring-1 ring-inset ring-brand-primary/10 rounded-[2.5rem]"></div>
            </div>
          </div>

          {/* Right Side: Content */}
          <div className="space-y-8">
            <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold leading-[0.95] tracking-tighter text-brand-primary">
              Welcome to the <br/>
              <span className="text-brand-accent">Future of Learning</span>
            </h2>
            
            <p className="text-gray-600 text-lg leading-relaxed max-w-xl">
              At City Educational Institutions, we recognize that every child’s learning journey is unique. With three specialized campuses, we offer personalized academic pathways that foster individual potential, encourage innovation, and prepare students to thrive in a rapidly evolving world.
            </p>

            <div className="grid sm:grid-cols-2 gap-6 pt-6">
              {[
                { icon: <School className="w-5 h-5 text-white" />, text: "Specialized Learning Environments" },
                { icon: <Lightbulb className="w-5 h-5 text-white" />, text: "Concept-Based Learning Approach" },
                { icon: <Users className="w-5 h-5 text-white" />, text: "Individual Attention & Student Support" },
                { icon: <TrendingUp className="w-5 h-5 text-white" />, text: "Future-Ready Skill Development" }
              ].map((feature, idx) => (
                <div key={idx} className="flex items-center gap-4 glass-card p-4 rounded-2xl border-white/40 hover:bg-white/90 hover:shadow-elite-hover transition-all cursor-default group/feat">
                  <div className="flex-shrink-0 w-10 h-10 rounded-xl bg-brand-accent flex items-center justify-center shadow-lg shadow-brand-accent/20 group-hover/feat:scale-110 transition-transform">
                    {feature.icon}
                  </div>
                  <p className="text-sm font-bold text-brand-primary tracking-tight">
                    {feature.text}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Our Schools Preview */}
      <section className="relative py-[clamp(4rem,10vh,8rem)] bg-transparent border-t border-brand-primary/5 px-4 sm:px-6 lg:px-8">
        {/* Ambient Light */}
        <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-brand-accent/5 rounded-full blur-[140px] -z-10 hidden sm:block"></div>
        
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto mb-20">
            <span className="inline-block py-1 px-4 rounded-full bg-brand-accent/10 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-6">
              Our Legacy
            </span>
            <h3 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold mb-8 tracking-tighter leading-none">
              <span className="text-brand-primary">Our Campuses of </span>
              <span className="text-brand-accent">Excellence</span>
            </h3>
            <p className="text-gray-500 text-xl leading-relaxed">
              Three specialized campuses, one unified vision — empowering every student to learn, grow, and succeed in their own unique way.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-10 lg:gap-14">
            {[
              { name: 'City Talent', desc: 'Nurturing creativity, confidence, and all-round excellence.', image: '/schools/city-talent-final.png', path: '/campuses/city-talent' },
              { name: 'City Elite', desc: 'Delivering advanced learning with a focus on performance and leadership.', image: 'https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?q=80&w=800&auto=format&fit=crop', path: '/campuses/city-elite' },
              { name: 'New Vision', desc: 'Shaping future-ready minds through innovation and technology.', image: 'https://images.unsplash.com/photo-1564981797816-1043664bf78d?q=80&w=800&auto=format&fit=crop', path: '/campuses/new-vision' }
            ].map((school, idx) => (
              <div key={idx} className="group relative flex flex-col items-center">
                <Link to={school.path} className="w-full aspect-[3/2] rounded-[2.5rem] overflow-hidden shadow-elite group-hover:shadow-2xl transition-all duration-700 relative border-4 border-white/20">
                  <div className="absolute inset-0 z-10 flex items-center justify-center">
                    <span className="text-white text-[10px] font-black uppercase tracking-[0.4em] opacity-0 group-hover:opacity-100 transition-all duration-500 translate-y-4 group-hover:translate-y-0 bg-brand-accent px-4 py-2 rounded-full">
                      View Campus
                    </span>
                  </div>
                  <img src={school.image} alt={school.name} className="w-full h-full object-cover transform group-hover:scale-110 transition-transform duration-1000 ease-out" />
                </Link>
                <div className="glass-card w-[90%] -mt-16 relative z-20 rounded-2xl p-6 group-hover:-translate-y-2 transition-all duration-700 flex flex-col items-center text-center">
                  <h4 className="text-2xl font-serif font-bold text-brand-primary mb-4 leading-none">{school.name}</h4>
                  <p className="text-gray-500 text-sm leading-relaxed mb-6">{school.desc}</p>
                  <Link to={school.path} className="inline-flex items-center text-[10px] font-black text-brand-accent group-hover:text-brand-primary transition-colors uppercase tracking-[0.25em] relative">
                    Explore Campus <ArrowRight className="w-3.5 h-3.5 ml-2 transform group-hover:translate-x-2 transition-transform" />
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
      
      {/* Philosophy Section */}
      <section className="relative py-[clamp(4rem,10vh,8rem)] bg-transparent px-4 sm:px-6 lg:px-8 border-t border-brand-primary/5 text-brand-primary">
        <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-brand-primary/5 rounded-full blur-[120px] -z-10 opacity-40 hidden sm:block"></div>
        
        <div className="text-center mb-20">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <span className="inline-block py-1.5 px-5 rounded-full border border-brand-accent/30 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-6">
              Our Purpose
            </span>
            <h3 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold mb-8 tracking-tighter">
              <span className="text-brand-primary">Our Educational </span>
              <span className="text-brand-accent">Philosophy</span>
            </h3>
            <p className="max-w-4xl mx-auto text-gray-500 text-xl leading-relaxed">
              At the core of our philosophy is a commitment to excellence, integrity, and innovation — creating a learning environment that not only develops academic strength but also shapes character, leadership, and lifelong success.
            </p>
          </motion.div>
        </div>

        <div className="max-w-7xl mx-auto">
          <div className="grid md:grid-cols-2 gap-10">
            <div className="glass-card rounded-[3.5rem] p-12 glass-card-hover border-white/60 premium-shadow silk-gradient group">
              <div className="w-16 h-16 rounded-2xl bg-brand-accent flex items-center justify-center mb-10 shadow-xl shadow-brand-accent/20 transition-transform group-hover:rotate-6"><Eye className="w-8 h-8 text-white" /></div>
              <h4 className="text-4xl font-serif font-bold text-brand-primary mb-6 tracking-tight leading-none">Future Vision</h4>
              <p className="text-gray-600 leading-relaxed text-lg">To build a future-ready learning ecosystem that transforms strong foundations into lifelong success, empowering students to think critically, act confidently, and lead with purpose in a rapidly evolving world.</p>
            </div>
            <div className="glass-card rounded-[3.5rem] p-12 glass-card-hover border-white/60 premium-shadow silk-gradient group">
              <div className="w-16 h-16 rounded-2xl bg-brand-accent flex items-center justify-center mb-10 shadow-xl shadow-brand-accent/20 transition-transform group-hover:-rotate-6"><Target className="w-8 h-8 text-white" /></div>
              <h4 className="text-4xl font-serif font-bold text-brand-primary mb-6 tracking-tight leading-none">Our Mission</h4>
              <p className="text-gray-600 leading-relaxed text-lg">To provide a solid academic and value-based foundation through innovative teaching, personalized mentorship, and disciplined learning — enabling every student to grow with confidence, achieve excellence, and contribute meaningfully to society.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Gallery CTA Banner - Compact Version */}
      <section className="relative py-4 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="relative overflow-hidden rounded-[2rem] bg-brand-accent premium-shadow">
            {/* Background Decorative Elements */}
            <div className="absolute top-0 right-0 w-1/2 h-full bg-gradient-to-l from-white/20 to-transparent"></div>
            <div className="absolute -bottom-24 -left-24 w-96 h-96 bg-white/10 rounded-full blur-3xl"></div>
            
            <div className="relative z-10 flex flex-col md:flex-row items-stretch justify-between">
              {/* Text Side */}
              <div className="md:w-3/5 px-8 md:px-16 py-8 md:py-12 space-y-2 text-center md:text-left">
                <motion.div
                  initial={{ opacity: 0, x: -50 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.8 }}
                >
                  <h3 className="text-3xl md:text-4xl font-serif font-bold text-white leading-tight">
                    Where Potential Begins, <br/>
                    <span className="text-brand-primary">Excellence Follows</span>
                  </h3>
                  <p className="text-white/90 text-base md:text-lg max-w-xl leading-relaxed mt-2">
                    Step into a dynamic learning environment where innovation meets opportunity. Our state-of-the-art facilities, engaging spaces, and enriching campus life empower students to explore, grow, and excel.
                  </p>
                  <div className="pt-4">
                    <Link 
                      to="/gallery" 
                      className="inline-flex items-center px-8 py-4 rounded-full bg-brand-primary text-white font-bold tracking-wider hover:bg-white hover:text-brand-primary transition-all duration-300 shadow-lg shadow-brand-primary/30 glow-on-hover uppercase text-sm"
                    >
                      View Campus Experience
                      <ArrowRight className="ml-3 w-5 h-5" />
                    </Link>
                  </div>
                </motion.div>
              </div>
              
              {/* Image Side - Full Bleed */}
              <div className="md:w-1/2 relative mt-4 md:mt-0 overflow-hidden">
                <motion.img 
                  initial={{ opacity: 0, scale: 1.05 }}
                  whileInView={{ opacity: 1, scale: 1 }}
                  viewport={{ once: true }}
                  transition={{ duration: 1 }}
                  src="/home/student_banner_v2.png" 
                  alt="Confident Student" 
                  className="absolute inset-0 w-full h-full object-cover object-[center_30%]"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Testimonials Section - Premium Grid Design */}
      <section className="relative py-16 bg-white overflow-hidden px-4 sm:px-6 lg:px-8 border-t border-gray-100">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h3 className="text-3xl md:text-5xl font-serif font-bold text-brand-primary tracking-tighter leading-none mb-6">
              Voices of Our <span className="text-brand-accent italic">Community</span>
            </h3>
            <p className="text-gray-500 text-lg md:text-xl max-w-2xl mx-auto">Hear from the parents who have entrusted their children's future with us.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {testimonials.map((t, i) => (
              <motion.div 
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.8, delay: i * 0.2 }}
                className="bg-brand-light/30 backdrop-blur-sm p-6 md:p-8 rounded-[2rem] border border-white shadow-xl shadow-gray-200/50 flex flex-col justify-between group hover:bg-white hover:-translate-y-2 transition-all duration-500"
              >
                <div className="space-y-4">
                  <div className="flex gap-1">
                    {[...Array(5)].map((_, starIndex) => (
                      <Star key={starIndex} className="w-3.5 h-3.5 fill-brand-accent text-brand-accent" />
                    ))}
                  </div>
                  <Quote className="w-8 h-8 text-brand-accent/10 mb-1" />
                  <p className="text-gray-600 text-sm md:text-base leading-relaxed italic">
                    "{t.text}"
                  </p>
                </div>
                
                <div className="flex items-center gap-4 mt-6 pt-4 border-t border-gray-100">
                  <div className="w-12 h-12 rounded-xl overflow-hidden shadow-md transform group-hover:rotate-3 transition-transform bg-gray-100">
                    <img 
                      src={`/testimonials/parent${i+1}.png`} 
                      alt={t.author} 
                      className="w-full h-full object-cover scale-110"
                    />
                  </div>
                  <div>
                    <h4 className="text-lg font-serif font-bold text-brand-primary leading-none">{t.author}</h4>
                    <p className="text-[10px] text-brand-accent font-bold tracking-widest uppercase mt-1">Verified Parent</p>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Stats Counter Section */}
      <section className="relative py-[clamp(4rem,10vh,8rem)] px-4 sm:px-6 lg:px-8 overflow-hidden">
        {/* Background with Overlay */}
        <div className="absolute inset-0 z-0">
          <img 
            src="/books_bg.png" 
            alt="Library Books" 
            className="w-full h-full object-cover grayscale"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-brand-accent/75 via-brand-accent/65 to-brand-accent/85 backdrop-blur-[1px]"></div>
        </div>

        <div className="max-w-7xl mx-auto relative z-10">
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-12 lg:gap-8 items-center text-center">
            
            {/* Stat 1: Teachers */}
            <div className="group">
              <div className="relative w-24 h-24 mx-auto mb-6">
                <div className="absolute inset-0 rounded-full border border-white/30 scale-125 group-hover:scale-150 transition-transform duration-700"></div>
                <div className="absolute inset-0 rounded-full border border-white/10 scale-150 group-hover:scale-[1.75] transition-transform duration-1000"></div>
                <div className="relative w-full h-full rounded-full bg-white flex items-center justify-center shadow-xl transform group-hover:scale-110 transition-transform duration-300 z-10">
                  <Users className="w-10 h-10 text-brand-accent" />
                </div>
              </div>
              <div className="text-3xl md:text-5xl font-serif font-bold text-white mb-2">100+</div>
              <div className="text-sm font-bold tracking-[0.2em] text-white/80 uppercase">Teacher & Staff</div>
            </div>

            {/* Stat 2: Students */}
            <div className="group">
              <div className="relative w-24 h-24 mx-auto mb-6">
                <div className="absolute inset-0 rounded-full border border-white/30 scale-125 group-hover:scale-150 transition-transform duration-700"></div>
                <div className="absolute inset-0 rounded-full border border-white/10 scale-150 group-hover:scale-[1.75] transition-transform duration-1000"></div>
                <div className="relative w-full h-full rounded-full bg-white flex items-center justify-center shadow-xl transform group-hover:scale-110 transition-transform duration-300 z-10">
                  <Users className="w-10 h-10 text-brand-accent" />
                </div>
              </div>
              <div className="text-3xl md:text-5xl font-serif font-bold text-white mb-2">1,600+</div>
              <div className="text-sm font-bold tracking-[0.2em] text-white/80 uppercase">Students</div>
            </div>

            {/* Stat 3: Grades */}
            <div className="group">
              <div className="relative w-24 h-24 mx-auto mb-6">
                <div className="absolute inset-0 rounded-full border border-white/30 scale-125 group-hover:scale-150 transition-transform duration-700"></div>
                <div className="absolute inset-0 rounded-full border border-white/10 scale-150 group-hover:scale-[1.75] transition-transform duration-1000"></div>
                <div className="relative w-full h-full rounded-full bg-white flex items-center justify-center shadow-xl transform group-hover:scale-110 transition-transform duration-300 z-10">
                  <Target className="w-10 h-10 text-brand-accent" />
                </div>
              </div>
              <div className="text-3xl md:text-5xl font-serif font-bold text-white mb-2">10</div>
              <div className="text-sm font-bold tracking-[0.2em] text-white/80 uppercase">Grades</div>
            </div>

            {/* Stat 4: Campuses */}
            <div className="group">
              <div className="relative w-24 h-24 mx-auto mb-6">
                <div className="absolute inset-0 rounded-full border border-white/30 scale-125 group-hover:scale-150 transition-transform duration-700"></div>
                <div className="absolute inset-0 rounded-full border border-white/10 scale-150 group-hover:scale-[1.75] transition-transform duration-1000"></div>
                <div className="relative w-full h-full rounded-full bg-white flex items-center justify-center shadow-xl transform group-hover:scale-110 transition-transform duration-300 z-10">
                  <School className="w-10 h-10 text-brand-accent" />
                </div>
              </div>
              <div className="text-3xl md:text-5xl font-serif font-bold text-white mb-2">3</div>
              <div className="text-sm font-bold tracking-[0.2em] text-white/80 uppercase">Campuses</div>
            </div>

          </div>
        </div>
      </section>

      {/* Admissions Popup */}
      <AnimatePresence>
        {showPopup && <AdmissionsPopup onClose={() => setShowPopup(false)} />}
      </AnimatePresence>
    </div>
  );
}
