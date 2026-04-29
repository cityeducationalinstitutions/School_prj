import { motion } from 'framer-motion';
import { 
  Calendar, 
  BookOpen, 
  BarChart3, 
  MessageSquare, 
  Bell, 
  CreditCard,
  CheckCircle2,
  Download,
  Smartphone
} from 'lucide-react';

const leftFeatures = [
  { icon: Calendar, label: 'Real-time Attendance', color: 'text-green-600', bgColor: 'bg-green-50' },
  { icon: BookOpen, label: 'Homework & Assignments', color: 'text-purple-600', bgColor: 'bg-purple-50' },
  { icon: BarChart3, label: 'Performance Reports', color: 'text-orange-600', bgColor: 'bg-orange-50' },
];

const rightFeatures = [
  { icon: MessageSquare, label: 'Instant Communication', color: 'text-blue-600', bgColor: 'bg-blue-50' },
  { icon: Bell, label: 'Important Notifications', color: 'text-red-600', bgColor: 'bg-red-50' },
  { icon: CreditCard, label: 'Fee Management', color: 'text-yellow-600', bgColor: 'bg-yellow-50' },
];

const bullets = [
  'Real-time Attendance & Updates',
  'Homework & Assignment Tracking',
  'Performance Reports & Analytics',
  'Instant Communication',
  'Fee Management & Reminders'
];

export default function SmartSchoolApp() {
  return (
    <section className="pt-12 pb-16 bg-white relative overflow-hidden">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="flex flex-col lg:flex-row items-center gap-12 lg:gap-16">
          
          {/* Left Side: Features & Phone Mockup (3-column layout) */}
          <div className="w-full lg:w-[58%] flex items-center justify-center gap-4 sm:gap-10">
            
            {/* Left Features Column */}
            <div className="flex flex-col gap-8 sm:gap-12">
              {leftFeatures.map((f, idx) => (
                <motion.div
                  key={idx}
                  initial={{ opacity: 0, x: -20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: idx * 0.1 }}
                  className="flex flex-col items-center text-center gap-2"
                >
                  <div className={`w-12 h-12 sm:w-14 sm:h-14 rounded-full ${f.bgColor} ${f.color} flex items-center justify-center shadow-md border border-white/50 hover:scale-110 transition-transform cursor-default`}>
                    <f.icon className="w-6 h-6 sm:w-7 sm:h-7" />
                  </div>
                  <span className="text-[9px] sm:text-[10px] font-bold text-gray-700 max-w-[60px] leading-tight">{f.label}</span>
                </motion.div>
              ))}
            </div>

            {/* Phone Mockup Center */}
            <motion.div
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8 }}
              className="relative z-20 w-[180px] sm:w-[240px] aspect-[1/2] rounded-[2.5rem] shadow-[0_20px_50px_-12px_rgba(0,0,0,0.25)] p-2 bg-black overflow-hidden border-[6px] border-[#1A1A1A]"
            >
              <img 
                src="/app_mockup.png" 
                alt="Smart School App Dashboard" 
                className="w-full h-full object-cover rounded-[2rem]"
              />
              {/* Dynamic Island Mockup */}
              <div className="absolute top-4 left-1/2 -translate-x-1/2 w-16 h-4 bg-black rounded-full z-30" />
            </motion.div>

            {/* Right Features Column */}
            <div className="flex flex-col gap-8 sm:gap-12">
              {rightFeatures.map((f, idx) => (
                <motion.div
                  key={idx}
                  initial={{ opacity: 0, x: 20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: idx * 0.1 }}
                  className="flex flex-col items-center text-center gap-2"
                >
                  <div className={`w-12 h-12 sm:w-14 sm:h-14 rounded-full ${f.bgColor} ${f.color} flex items-center justify-center shadow-md border border-white/50 hover:scale-110 transition-transform cursor-default`}>
                    <f.icon className="w-6 h-6 sm:w-7 sm:h-7" />
                  </div>
                  <span className="text-[9px] sm:text-[10px] font-bold text-gray-700 max-w-[60px] leading-tight">{f.label}</span>
                </motion.div>
              ))}
            </div>

          </div>

          {/* Right Side: Content */}
          <div className="w-full lg:w-[42%] text-left">
            <motion.div
              initial={{ opacity: 0, x: 30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8 }}
            >
              {/* Badge */}
              <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-orange-50 border border-orange-100 mb-6">
                <Smartphone className="w-3.5 h-3.5 text-[#F97316]" />
                <span className="text-[#F97316] font-bold text-[10px] tracking-wider uppercase">Connect · Engage · Grow</span>
              </div>

              {/* Heading */}
              <h2 className="text-4xl md:text-5xl font-serif font-bold text-[#0F172A] mb-6 leading-[1.1]">
                Smart School <br />
                <span className="text-[#F97316]">App</span>
              </h2>

              <p className="text-gray-500 text-base leading-relaxed mb-6 max-w-md">
                Everything you need for a better school experience – in your hand, anytime, anywhere.
              </p>

              {/* Bullet Points */}
              <div className="space-y-3 mb-8">
                {bullets.map((bullet, idx) => (
                  <div key={idx} className="flex items-center gap-3">
                    <div className="w-4 h-4 rounded-full border border-orange-200 flex items-center justify-center bg-white">
                      <CheckCircle2 className="w-2.5 h-2.5 text-[#F97316]" />
                    </div>
                    <span className="text-gray-700 text-sm font-medium">{bullet}</span>
                  </div>
                ))}
              </div>

              {/* Download Button */}
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className="group relative flex items-center gap-2 px-8 py-4 rounded-xl bg-gradient-to-r from-[#F97316] to-[#FF8C33] text-white font-bold text-lg shadow-lg shadow-orange-500/20 overflow-hidden mb-8"
              >
                <div className="absolute inset-0 bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity" />
                <Download className="w-5 h-5" />
                <span>Download App</span>
              </motion.button>
              
              {/* Store Badges Section */}
              <div>
                <p className="text-[10px] font-bold text-gray-400 mb-3 uppercase tracking-wider">Available on</p>
                <div className="flex items-center gap-3">
                  <button className="h-9 hover:scale-105 transition-transform">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" alt="Google Play" className="h-full" />
                  </button>
                  <button className="h-9 hover:scale-105 transition-transform">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" alt="App Store" className="h-full" />
                  </button>
                </div>
              </div>
            </motion.div>
          </div>

        </div>
      </div>
    </section>
  );
}
