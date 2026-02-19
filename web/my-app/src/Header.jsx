import { useState } from 'react'
import axios from 'axios'

function App() {
  const [file, setFile] = useState(null);
  const [isDragging, setIsDragging] = useState(false);
  const [status, setStatus] = useState('idle'); // idle, uploading, success, error

  const handleDragOver = (e) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => {
    setIsDragging(false);
  };

  const handleDrop = (e) => {
    e.preventDefault();
    setIsDragging(false);
    const uploadedFile = e.dataTransfer.files[0];
    if (uploadedFile) {
      setFile(uploadedFile);
      setStatus('idle'); // รีเซ็ตสถานะเมื่อมีไฟล์ใหม่
    }
  };

  // --- ฟังก์ชันเรียก API ---
  const handleUpload = async () => {
    if (!file) return;

    setStatus('uploading');

    // เตรียมข้อมูลเพื่อส่งแบบ Multipart (สำหรับไฟล์)
    const formData = new FormData();
    formData.append('file', file);

    try {
      // ใส่ URL ของ API Gateway หรือ Flask Server ของคุณที่นี่
      const response = await axios.post('https://YOUR_API_GATEWAY_URL/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      console.log("Response:", response.data);
      setStatus('success');
    } catch (error) {
      console.error("Upload Error:", error);
      setStatus('error');
    }
  };

  return (
    <div className="h-195 w-120 bg-slate-50 flex items-center justify-center p-6">
      <div className="w-full max-w-xl space-y-4">
        
        {/* Drop Zone */}
        <div 
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          className={`
            w-full h-170 border-4 border-dashed rounded-3xl flex flex-col items-center justify-center transition-all duration-300
            ${isDragging 
              ? "border-blue-500 bg-blue-50 scale-105 shadow-2xl" 
              : "border-slate-300 bg-white shadow-md"}
          `}
        >
          <div className="text-center">
            <div className="text-5xl mb-4">
              {file ? "📄" : "☁️"}
            </div>
            
            <h2 className="text-xl font-bold text-slate-700">
              {file ? file.name : "ลากไฟล์มาวางที่นี่เพื่ออัปโหลด"}
            </h2>
            
            {!file && (
              <p className="text-slate-400 mt-2">รองรับไฟล์ทุกประเภท</p>
            )}

            {file && status !== 'uploading' && (
              <button 
                onClick={() => { setFile(null); setStatus('idle'); }}
                className="mt-3 text-sm text-yellow-400 hover:underline cursor-pointer"
              >
                เปลี่ยนไฟล์
              </button>
            )}
          </div>
        </div>

        {/* ปุ่มกดส่ง API */}
        {file && (
          <button
            onClick={handleUpload}
            disabled={status === 'uploading'}
            className={`
              w-full py-4 rounded-2xl font-bold text-white shadow-lg transition-all active:scale-95
              ${status === 'uploading' ? "bg-slate-400 cursor-not-allowed" : "bg-blue-400 hover:bg-blue-500"}
              ${status === 'success' ? "bg-green-400 hover:bg-green-500" : ""}
              ${status === 'error' ? "bg-red-400 hover:bg-red-500" : ""}
            `}
          >
            {status === 'idle' && "กดเพื่ออัปโหลดไปที่ S3"}
            {status === 'uploading' && "กำลังส่งไฟล์... 🚀"}
            {status === 'success' && "อัปโหลดสำเร็จ! ✅"}
            {status === 'error' && "เกิดข้อผิดพลาด ลองใหม่อีกครั้ง"}
          </button>
        )}

      </div>
    </div>
  )
}

export default App
