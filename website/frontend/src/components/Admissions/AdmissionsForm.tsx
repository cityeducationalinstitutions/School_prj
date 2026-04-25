import { useState } from 'react';
import { motion } from 'framer-motion';
import { Send, User, Mail, Phone, GraduationCap, Building } from 'lucide-react';

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
    // Simulate submission
    setSubmitted(true);
    setTimeout(() => setSubmitted(false), 5000);
  };

  return (
    <section id="admission-form" className="py-[clamp(4rem,10vh,8rem)] bg-white relative overflow-hidden">
      {/* Background Decorative Blobs */}
      <div className="absolute top-1/4 right-0 w-96 h-96 bg-brand-accent/5 rounded-full blur-[100px] -z-10 translate-x-1/2"></div>
      <div className="absolute bottom-1/4 left-0 w-72 h-72 bg-brand-primary/5 rounded-full blur-[80px] -z-10 -translate-x-1/2"></div>

      <div className="max-w-7xl mx-auto px-6">
        <div className="grid lg:grid-cols-2 gap-20 items-center">
          
          {/* Left Side: Content */}
          <div className="space-y-10">
            <div className="space-y-6">
              <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block">Inquiry Form</span>
              <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary tracking-tighter leading-[0.9]">
                Start Your Child's <br/>
                <span className="text-brand-accent italic font-light drop-shadow-sm">Excellence Journey.</span>
              </h2>
              <div className="w-20 h-1 bg-brand-accent/20 rounded-full"></div>
              
              <p className="text-gray-500 font-light text-lg leading-relaxed max-w-xl">
                Fill out the form below and our admissions team will get in touch with you within 24 hours to guide you through the process.
              </p>
            </div>

            <div className="space-y-8">
              {[
                { icon: <GraduationCap className="w-6 h-6" />, title: "Personalized Counseling", desc: "One-on-one sessions with our academic advisors." },
                { icon: <Building className="w-6 h-6" />, title: "Campus Interaction", desc: "Experience our state-of-the-art facilities first-hand." }
              ].map((item, idx) => (
                <div key={idx} className="flex gap-6 items-start group">
                  <div className="w-12 h-12 rounded-2xl bg-brand-primary/5 flex items-center justify-center text-brand-accent group-hover:bg-brand-accent group-hover:text-white transition-all duration-500 transform group-hover:rotate-6">
                    {item.icon}
                  </div>
                  <div>
                    <h4 className="text-lg font-bold text-brand-primary tracking-tight">{item.title}</h4>
                    <p className="text-sm text-gray-500 font-light">{item.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Right Side: Form Card */}
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="relative"
          >
            <div className="glass-card rounded-[3rem] p-8 md:p-12 border-white shadow-elite relative z-10 overflow-hidden">
              {submitted ? (
                <motion.div 
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  className="text-center py-20 space-y-6"
                >
                  <div className="w-20 h-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-8 shadow-inner">
                    <Send className="w-10 h-10" />
                  </div>
                  <h3 className="text-3xl font-serif text-brand-primary">Thank You!</h3>
                  <p className="text-gray-500 font-light">Your enquiry has been received. Our team will contact you shortly.</p>
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
                    <div className="relative">
                      <User className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                      <input 
                        type="text" 
                        required
                        placeholder="Parent Full Name"
                        className="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/20 transition-all outline-none"
                        value={formState.name}
                        onChange={(e) => setFormState({...formState, name: e.target.value})}
                      />
                    </div>
                    <div className="relative">
                      <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                      <input 
                        type="email" 
                        required
                        placeholder="Email Address"
                        className="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/20 transition-all outline-none"
                        value={formState.email}
                        onChange={(e) => setFormState({...formState, email: e.target.value})}
                      />
                    </div>
                  </div>

                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="relative">
                      <Phone className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                      <input 
                        type="tel" 
                        required
                        placeholder="Phone Number"
                        className="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/20 transition-all outline-none"
                        value={formState.phone}
                        onChange={(e) => setFormState({...formState, phone: e.target.value})}
                      />
                    </div>
                    <div className="relative">
                      <GraduationCap className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                      <select 
                        required
                        className="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/20 transition-all outline-none appearance-none"
                        value={formState.grade}
                        onChange={(e) => setFormState({...formState, grade: e.target.value})}
                      >
                        <option value="">Select Grade</option>
                        <option value="nursery">Nursery / PP1</option>
                        <option value="primary">Primary (Class 1-5)</option>
                        <option value="middle">Middle (Class 6-8)</option>
                        <option value="secondary">Secondary (Class 9-10)</option>
                      </select>
                    </div>
                  </div>

                  <div className="relative">
                    <Building className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <select 
                      required
                      className="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/20 transition-all outline-none appearance-none"
                      value={formState.campus}
                      onChange={(e) => setFormState({...formState, campus: e.target.value})}
                    >
                      <option value="">Preferred Campus</option>
                      <option value="city-talent">City Talent School</option>
                      <option value="city-elite">City Elite School</option>
                      <option value="new-vision">New Vision School</option>
                    </select>
                  </div>

                  <textarea 
                    placeholder="Any specific questions? (Optional)"
                    rows={4}
                    className="w-full p-6 rounded-3xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/20 transition-all outline-none resize-none"
                    value={formState.message}
                    onChange={(e) => setFormState({...formState, message: e.target.value})}
                  ></textarea>

                  <button 
                    type="submit"
                    className="w-full py-5 bg-brand-primary text-white font-bold text-xs tracking-widest uppercase rounded-2xl shadow-xl shadow-brand-primary/10 hover:bg-brand-accent transition-all duration-500"
                  >
                    Submit Application Enquiry
                  </button>
                </form>
              )}
            </div>

            {/* Decorative Element Behind Card */}
            <div className="absolute -inset-4 border border-brand-accent/10 rounded-[3.5rem] -z-10 pointer-events-none"></div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default AdmissionsForm;
