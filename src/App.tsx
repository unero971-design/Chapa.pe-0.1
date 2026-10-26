import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import TransitMapPage from '@/pages/TransitMapPage';

export default function App() {
  return <BrowserRouter><div className="h-screen w-screen bg-slate-100"><Routes><Route path="/" element={<TransitMapPage />} /><Route path="*" element={<Navigate to="/" replace />} /></Routes></div></BrowserRouter>;
}
