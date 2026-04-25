import AboutHero from '../components/About/AboutHero';
import ManagementProfiles from '../components/Management/ManagementProfiles';

const Management = () => {
  return (
    <div className="flex flex-col">
      <AboutHero 
        title="About"
        subtitle="City Institutional Leadership"
        description="Guided by a visionary legacy and a commitment to nurturing the future leaders of our society."
        image="/about_hero.png"
      />
      <ManagementProfiles />
    </div>
  );
};

export default Management;
