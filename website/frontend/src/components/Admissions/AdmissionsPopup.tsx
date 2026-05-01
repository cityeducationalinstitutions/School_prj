import { useState } from 'react';
import { motion } from 'framer-motion';
import { X, User, Phone, Send } from 'lucide-react';

interface AdmissionsPopupProps {
  onClose: () => void;
}

const AdmissionsPopup = ({ onClose }: AdmissionsPopupProps) => {
  const [formState, setFormState] = useState({
    name: '',
    phone: '',
    grade: '',
    campus: ''
  });

  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
    setTimeout(() => onClose(), 3000);
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center px-4">
      {/* Backdrop - Clear/Minimal for full background visibility */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        onClick={onClose}
        className="absolute inset-0 bg-black/10"
      />

      {/* Popup Container - Compact Square Style */}
      <motion.div 
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
        className="relative w-full max-w-[400px] aspect-square bg-white rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.15)] overflow-hidden border border-gray-100 flex flex-col justify-center"
      >
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-1.5 rounded-full bg-gray-50 hover:bg-brand-accent hover:text-white transition-all z-20 group"
        >
          <X className="w-4 h-4 transition-transform group-hover:rotate-90" />
        </button>

        <div className="p-8 md:p-10 relative z-10 flex flex-col h-full">
          {submitted ? (
            <motion.div 
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="text-center my-auto space-y-4"
            >
              <div className="w-16 h-16 bg-green-50 text-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <Send className="w-8 h-8" />
              </div>
              <h3 className="text-2xl font-serif text-brand-primary">Thank You!</h3>
              <p className="text-sm text-gray-500 font-light px-4">Enquiry received. We'll be in touch soon.</p>
            </motion.div>
          ) : (
            <div className="flex flex-col justify-center h-full space-y-6">
              <div className="text-center space-y-2">
                <h2 className="text-2xl font-serif text-brand-primary tracking-tight leading-none">
                  Admission Inquiry <br/>
                  <span className="text-brand-accent italic font-light">2026-27 Open</span>
                </h2>
                <p className="text-[10px] text-gray-400 font-bold uppercase tracking-[0.2em] pt-1">
                  Start Your Journey
                </p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="relative">
                  <User className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input 
                    type="text" 
                    required
                    placeholder="Full Name"
                    className="w-full pl-11 pr-4 py-3.5 rounded-xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/10 transition-all outline-none"
                    value={formState.name}
                    onChange={(e) => setFormState({...formState, name: e.target.value})}
                  />
                </div>

                <div className="relative">
                  <Phone className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input 
                    type="tel" 
                    required
                    placeholder="Mobile Number"
                    className="w-full pl-11 pr-4 py-3.5 rounded-xl bg-gray-50 border-none text-sm focus:ring-2 focus:ring-brand-accent/10 transition-all outline-none"
                    value={formState.phone}
                    onChange={(e) => setFormState({...formState, phone: e.target.value})}
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <select 
                    required
                    className="w-full px-4 py-3.5 rounded-xl bg-gray-50 border-none text-xs focus:ring-2 focus:ring-brand-accent/10 transition-all outline-none appearance-none cursor-pointer"
                    value={formState.grade}
                    onChange={(e) => setFormState({...formState, grade: e.target.value})}
                  >
                    <option value="">Grade</option>
                    <option value="preschool">Pre-School</option>
                    <option value="primary">Class 1-5</option>
                    <option value="middle">Class 6-8</option>
                    <option value="secondary">Class 9-10</option>
                  </select>
                  <select 
                    required
                    className="w-full px-4 py-3.5 rounded-xl bg-gray-50 border-none text-xs focus:ring-2 focus:ring-brand-accent/10 transition-all outline-none appearance-none cursor-pointer"
                    value={formState.campus}
                    onChange={(e) => setFormState({...formState, campus: e.target.value})}
                  >
                    <option value="">Campus</option>
                    <option value="city-talent">City Talent</option>
                    <option value="new-vision">New Vision</option>
                    <option value="city-elite">City Elite</option>
                  </select>
                </div>

                <button 
                  type="submit"
                  className="w-full py-4 bg-brand-primary text-white font-bold text-[10px] tracking-[0.2em] uppercase rounded-xl shadow-lg hover:bg-brand-accent transition-all duration-500 mt-2 active:scale-95"
                >
                  Send Inquiry
                </button>
              </form>
            </div>
          )}
        </div>
      </motion.div>
    </div>
  );
};

export default AdmissionsPopup;
