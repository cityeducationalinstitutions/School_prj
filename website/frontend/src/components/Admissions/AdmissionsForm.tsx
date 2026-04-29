import { useState } from 'react';
import { motion } from 'framer-motion';
import { Send, User, Mail, Phone, GraduationCap, Building, MessageSquare, ShieldCheck, ChevronRight } from 'lucide-react';

const AdmissionsForm = () => {
  const [formState, setFormState] = useState({
    name: '',
    email: '',
    phone: '',
    grade: '',
    campus: '',
    message: ''
  });

  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
    setTimeout(() => setSubmitted(false), 5000);
  };

  return (
    <section id="admission-form" className="pt-24 pb-12 bg-[#FAFBFF] relative overflow-hidden">
      {/* Background Accents */}
      <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 translate-x-1/3 -translate-y-1/3"></div>
      <div className="absolute bottom-0 left-0 w-[400px] h-[400px] bg-brand-primary/5 rounded-full blur-[100px] -z-10 -translate-x-1/3 translate-y-1/3"></div>

      <div className="max-w-7xl mx-auto px-6">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          
          {/* Left Side: Visuals & Branding */}
          <div className="space-y-12">
            <div className="space-y-8">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-brand-accent/10 flex items-center justify-center">
                  <div className="w-2 h-2 rounded-full bg-brand-accent"></div>
                </div>
                <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase">Inquiry Form</span>
              </div>
              
              <h2 className="text-[clamp(2.5rem,6vh,4rem)] font-serif text-[#0A1629] leading-[1.05] tracking-tight">
                Start Your Child's <br/>
                <span className="text-brand-accent">Excellence Journey.</span>
              </h2>
              
              <div className="w-24 h-1 bg-gradient-to-r from-brand-accent to-transparent rounded-full"></div>
              
              <p className="text-gray-500 text-lg leading-relaxed max-w-xl font-medium">
                Fill out the form below and our admissions team will get in touch with you within 24 hours to guide you through the process.
              </p>
            </div>

            {/* Feature Cards */}
            <div className="grid sm:grid-cols-2 gap-6">
              {[
                { icon: <GraduationCap className="w-6 h-6" />, title: "Personalized Counseling", desc: "One-on-one sessions with our advisors." },
                { icon: <Building className="w-6 h-6" />, title: "Campus Interaction", desc: "Visit our world-class facilities." }
              ].map((item, idx) => (
                <div key={idx} className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 group hover:shadow-md transition-all duration-300">
                  <div className="w-12 h-12 rounded-xl bg-brand-accent/10 flex items-center justify-center text-brand-accent mb-4 group-hover:scale-110 transition-transform">
                    {item.icon}
                  </div>
                  <h4 className="text-base font-bold text-[#0A1629] mb-1">{item.title}</h4>
                  <p className="text-sm text-gray-500 leading-snug">{item.desc}</p>
                </div>
              ))}
            </div>
          </div>

          {/* Right Side: Inquiry Card */}
          <motion.div 
            initial={{ opacity: 0, x: 30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="relative"
          >
            <div className="bg-white rounded-[3rem] p-8 md:p-12 shadow-[0_32px_64px_-16px_rgba(0,0,0,0.08)] border border-white relative z-10">
              {submitted ? (
                <motion.div 
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  className="text-center py-20 space-y-6"
                >
                  <div className="w-20 h-20 bg-green-50 text-green-500 rounded-full flex items-center justify-center mx-auto mb-8">
                    <Send className="w-10 h-10" />
                  </div>
                  <h3 className="text-3xl font-serif text-[#0A1629]">Thank You!</h3>
                  <p className="text-gray-500 font-medium">Your inquiry has been received. Our team will contact you shortly.</p>
                  <button 
                    onClick={() => setSubmitted(false)}
                    className="text-brand-accent font-bold text-xs tracking-widest uppercase hover:underline"
                  >
                    Submit another enquiry
                  </button>
                </motion.div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-6">
                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="relative group">
                      <User className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 group-focus-within:text-brand-accent transition-colors" />
                      <input 
                        type="text" 
                        required
                        placeholder="Parent Full Name"
                        className="w-full pl-12 pr-4 py-4 rounded-xl bg-gray-50 border border-transparent focus:border-brand-accent/20 focus:bg-white focus:ring-4 focus:ring-brand-accent/5 transition-all outline-none text-sm font-medium"
                        value={formState.name}
                        onChange={(e) => setFormState({...formState, name: e.target.value})}
                      />
                    </div>
                    <div className="relative group">
                      <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 group-focus-within:text-brand-accent transition-colors" />
                      <input 
                        type="email" 
                        required
                        placeholder="Email Address"
                        className="w-full pl-12 pr-4 py-4 rounded-xl bg-gray-50 border border-transparent focus:border-brand-accent/20 focus:bg-white focus:ring-4 focus:ring-brand-accent/5 transition-all outline-none text-sm font-medium"
                        value={formState.email}
                        onChange={(e) => setFormState({...formState, email: e.target.value})}
                      />
                    </div>
                  </div>

                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="relative group">
                      <Phone className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 group-focus-within:text-brand-accent transition-colors" />
                      <input 
                        type="tel" 
                        required
                        placeholder="Phone Number"
                        className="w-full pl-12 pr-4 py-4 rounded-xl bg-gray-50 border border-transparent focus:border-brand-accent/20 focus:bg-white focus:ring-4 focus:ring-brand-accent/5 transition-all outline-none text-sm font-medium"
                        value={formState.phone}
                        onChange={(e) => setFormState({...formState, phone: e.target.value})}
                      />
                    </div>
                    <div className="relative group">
                      <GraduationCap className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 group-focus-within:text-brand-accent transition-colors pointer-events-none" />
                      <select 
                        required
                        className="w-full pl-12 pr-10 py-4 rounded-xl bg-gray-50 border border-transparent focus:border-brand-accent/20 focus:bg-white focus:ring-4 focus:ring-brand-accent/5 transition-all outline-none text-sm font-medium appearance-none"
                        value={formState.grade}
                        onChange={(e) => setFormState({...formState, grade: e.target.value})}
                      >
                        <option value="">Select Grade</option>
                        <option value="nursery">Nursery / PP1</option>
                        <option value="primary">Primary (Class 1-5)</option>
                        <option value="middle">Middle (Class 6-8)</option>
                        <option value="secondary">Secondary (Class 9-10)</option>
                      </select>
                      <ChevronRight className="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 rotate-90" />
                    </div>
                  </div>

                  <div className="relative group">
                    <Building className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 group-focus-within:text-brand-accent transition-colors pointer-events-none" />
                    <select 
                      required
                      className="w-full pl-12 pr-10 py-4 rounded-xl bg-gray-50 border border-transparent focus:border-brand-accent/20 focus:bg-white focus:ring-4 focus:ring-brand-accent/5 transition-all outline-none text-sm font-medium appearance-none"
                      value={formState.campus}
                      onChange={(e) => setFormState({...formState, campus: e.target.value})}
                    >
                      <option value="">Preferred Campus</option>
                      <option value="city-talent">City Talent School</option>
                      <option value="city-elite">City Elite School</option>
                      <option value="new-vision">New Vision School</option>
                    </select>
                    <ChevronRight className="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 rotate-90" />
                  </div>

                  <div className="relative group">
                    <MessageSquare className="absolute left-4 top-6 w-4 h-4 text-gray-400 group-focus-within:text-brand-accent transition-colors" />
                    <textarea 
                      placeholder="Any specific questions? (Optional)"
                      rows={4}
                      className="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border border-transparent focus:border-brand-accent/20 focus:bg-white focus:ring-4 focus:ring-brand-accent/5 transition-all outline-none text-sm font-medium resize-none"
                      value={formState.message}
                      onChange={(e) => setFormState({...formState, message: e.target.value})}
                    ></textarea>
                  </div>

                  <button 
                    type="submit"
                    className="w-full py-5 bg-[#0A1629] text-white font-bold text-sm tracking-widest uppercase rounded-xl hover:bg-brand-accent transition-all duration-300 shadow-xl shadow-[#0A1629]/20 flex items-center justify-center gap-3"
                  >
                    Submit Application Enquiry
                    <ChevronRight className="w-5 h-5" />
                  </button>

                  <div className="flex items-center justify-center gap-2 pt-4">
                    <ShieldCheck className="w-4 h-4 text-brand-accent" />
                    <p className="text-[10px] text-gray-400 font-bold tracking-wider uppercase">Your information is safe and secure with us</p>
                  </div>
                </form>
              )}
            </div>

            {/* Glassmorphism Accents */}
            <div className="absolute -top-6 -right-6 w-24 h-24 bg-brand-accent/10 rounded-full blur-2xl -z-10"></div>
            <div className="absolute -bottom-6 -left-6 w-32 h-32 bg-brand-primary/10 rounded-full blur-3xl -z-10"></div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default AdmissionsForm;
