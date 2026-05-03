import { motion } from 'framer-motion';
import { X } from 'lucide-react';

interface ResultsPopupProps {
  onClose: () => void;
}

const ResultsPopup = ({ onClose }: ResultsPopupProps) => {
  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center px-4">
      {/* Backdrop */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        onClick={onClose}
        className="absolute inset-0 bg-black/40 backdrop-blur-sm"
      />

      {/* Popup Container */}
      <motion.div 
        initial={{ opacity: 0, scale: 0.9, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.9, y: 20 }}
        className="relative w-full max-w-[800px] bg-white rounded-2xl shadow-[0_20px_50px_rgba(0,0,0,0.3)] overflow-hidden border border-white/20"
      >
        {/* Close Button */}
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-2 rounded-full bg-black/20 hover:bg-brand-accent text-white transition-all z-30 group backdrop-blur-md"
        >
          <X className="w-5 h-5 transition-transform group-hover:rotate-90" />
        </button>

        {/* Results Image */}
        <div className="relative w-full aspect-[4/3] md:aspect-[1.2/1]">
          <img 
            src="/ssc_results_2026.png" 
            alt="SSC 2026 Results" 
            className="w-full h-full object-contain bg-[#f3f4f6]"
          />
        </div>
        
        {/* Optional: Simple Banner at bottom if needed, but user said "Just use this image" */}
        <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/60 to-transparent py-8 px-6 pointer-events-none">
            <p className="text-white text-xs font-bold tracking-[0.2em] uppercase opacity-0">SSC 2026 Results</p>
        </div>
      </motion.div>
    </div>
  );
};

export default ResultsPopup;
