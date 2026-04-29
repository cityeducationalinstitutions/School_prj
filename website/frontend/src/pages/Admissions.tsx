import { useEffect } from 'react';
import AdmissionsHero from '../components/Admissions/AdmissionsHero';
import AdmissionsForm from '../components/Admissions/AdmissionsForm';
import AdmissionJourney from '../components/Admissions/AdmissionJourney';
import MetricsSection from '../components/Campus/MetricsSection';
import { Target, History, Users, ShieldCheck } from 'lucide-react';

const Admissions = () => {
  // Scroll to top on load
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  const admissionMetrics = [
    { value: "100%", label: "Academic Results", icon: <Target className="w-5 h-5 text-brand-accent" /> },
    { value: "20+", label: "Years Excellence", icon: <History className="w-5 h-5 text-brand-accent" /> },
    { value: "1500+", label: "Enrolled Students", icon: <Users className="w-5 h-5 text-brand-accent" /> },
    { value: "100+", label: "Total Staff", icon: <ShieldCheck className="w-5 h-5 text-brand-accent" /> },
  ];

  return (
    <div className="bg-brand-light flex flex-col">
      <AdmissionsHero />
      <AdmissionsForm />
      <AdmissionJourney />
      <MetricsSection customMetrics={admissionMetrics} />
    </div>
  );
};

export default Admissions;
